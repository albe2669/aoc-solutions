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
             01 current-value pic S9(5) value 50.
             01 new-value pic 9(2).
             01 zero-seen pic 9(5) value 0.
             01 direction pic x(1).
             01 angles pic 9(5).
             01 rem pic 9(2).
             01 result pic 9(2).


       procedure division.
       main.
           open input day1-file.
               perform until ws-eof='Y'
                   read day1-file
                       at end move 'Y' to ws-eof
                       not at end perform compute-line
                   end-read
               end-perform.
               display "zeroes seen: " zero-seen.
           close day1-file.
           stop run.
          
       compute-line.
           display " ".
           display "current-value: " current-value.
           move day1-record(1:1) to direction.
           move day1-record(2:) to angles.



           if direction = "L"
             subtract angles from current-value
           else
             add angles to current-value
           end-if

           divide current-value by 100 giving result remainder
           current-value

           if current-value equal 0
             add 1 to zero-seen
           end-if

           display "record: " day1-record.
           display "direction: " direction.
           display "angles: " angles.
           display "new value: " new-value.
           display "current-value: " current-value.
           display "result: " result
           display "rem: " rem.
           display "zero-seen: " zero-seen.
       
        
