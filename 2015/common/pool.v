module common

// Iterator is a sequence of work items for a Pool. Implement next() to yield
// the next job, or none when the sequence is exhausted.
pub interface Iterator {
mut:
	next() ?int
}

// JobResult wraps a work function output, because channels cannot carry option
// types directly.
pub struct JobResult {
	v     int
	valid bool
}

// Pool runs jobs from an Iterator across a fixed set of worker threads. The
// first job that yields a result wins: pending jobs are cancelled and the
// result is returned. Workers persist until the iterator is exhausted, so
// threads are reused for every job in the sequence.
pub struct Pool {
	work_fn fn (job int) ?int = unsafe { nil }
	threads int
}

pub fn new_pool(threads int, work_fn fn (job int) ?int) Pool {
	return Pool{
		work_fn: work_fn
		threads: threads
	}
}

fn pool_worker(jobs chan int, work_fn fn (job int) ?int, results chan JobResult, exits chan int) {
	for {
		job := <-jobs or { break }
		mut res := JobResult{}
		if v := work_fn(job) {
			res = JobResult{v: v, valid: true}
		}
		results <- res or { break }
	}
	exits <- 1
}

fn feed_jobs(mut iter Iterator, jobs chan int) {
	for {
		job := iter.next() or {
			jobs.close()
			return
		}
		jobs <- job or { return }
	}
}

// work runs the pool until a job yields a result. All pending and running work
// is cancelled as soon as a result is found. If every job completes without a
// result, work returns none.
pub fn (mut p Pool) work(mut iter Iterator) ?int {
	jobs := chan int{cap: p.threads * 2}
	results := chan JobResult{cap: p.threads}
	exits := chan int{cap: p.threads}
	w := p.work_fn
	for _ in 0 .. p.threads {
		spawn fn [w, jobs, results, exits] () {
			pool_worker(jobs, w, results, exits)
		}()
	}
	spawn feed_jobs(mut iter, jobs)
	mut remaining := p.threads
	for {
		select {
			res := <-results {
				if res.valid {
					return p.finish(jobs, results, exits, remaining, res.v)
				}
			}
			e := <-exits {
				remaining -= e
				if remaining == 0 {
					// a worker can report its exit before the main loop has
					// read its last buffered result, so the results buffer is
					// drained before declaring failure
					mut res := JobResult{}
					for results.try_pop(mut res) == .success {
						if res.valid {
							return p.finish(jobs, results, exits, 0, res.v)
						}
					}
					return none
				}
			}
		}
	}
	return none
}

// finish stops all workers and waits for their exit reports, so worker
// threads never use pool channels after work returns
fn (mut p Pool) finish(jobs chan int, results chan JobResult, exits chan int, remaining int, v int) int {
	jobs.close()
	results.close()
	mut left := remaining
	for left > 0 {
		e := <-exits or { break }
		left -= e
	}
	return v
}
