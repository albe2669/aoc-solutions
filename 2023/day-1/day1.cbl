       *> this is only for the first star of day one
       *> what an absolutely terrible idea this was.
       identification  division.
       program-id. day1.

       environment division.
           input-output section.
               file-control.
               select day1-file assign to "day1.dat"
               organization is line sequential.
       
       data division.
           file section.
               *> read each line of the file
               fd day1-file.
               01 day1-record pic x(80).    

               01 ws-eof pic a(1).

           working-storage section.
               01 keep-going pic x(1) value 'Y'.
               01 i pic 9(2) value 1.
               01 first-digit pic x(1).
               01 last-digit pic x(1).
               01 num pic 9(2).
               01 calced-sum pic 9(5).

       procedure division.
       main.
           open input day1-file.
               perform until ws-eof='Y'
                   read day1-file
                       at end move 'Y' to ws-eof
                       not at end perform compute-line
                   end-read
               end-perform.
               display "sum is " calced-sum.
           close day1-file.
           stop run.
          
       compute-line.
           move 1 to i.
           move space to first-digit.
           move space to last-digit.

           perform find-first-digit.
           perform find-last-digit.

           string first-digit last-digit delimited by space
               into num
           end-string.

           compute calced-sum = calced-sum + num.
       
       find-first-digit.
           move 'Y' to keep-going.

           perform until keep-going='N'
               *> if there is no more data, stop
               if day1-record(i:1) = space OR i >= length of day1-record
                   move 'N' to keep-going
               else if day1-record(i:1) numeric
                   move day1-record(i:1) to first-digit
                   move 'N' to keep-going
               end-if

               add 1 to i
           end-perform.
        
       find-last-digit.
           move length of day1-record to i.
           move 'Y' to keep-going.

           perform until keep-going='N'
               *> if there is no more data, stop
               if i = 0 
                   move 'N' to keep-going
               else if day1-record(i:1) numeric
                   move day1-record(i:1) to last-digit
                   move 'N' to keep-going
               end-if

               add -1 to i
           end-perform.
           
