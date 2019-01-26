# This is a comment  - commenting  your  scripts  will  make  them
# more  understandable  for  yourself  and  others.
# Comments  begin  with  the  hash  symbol #
###  Store  today ’s year in a variable  called "year"
$year=(get-date -UFormat "%Y")
###  Ask  the  user  for  their  name  and  store  in  variable "name"
$name=read-host "What␣is␣you␣name?"
###  Write  out a reply  using  the  values  name  and  day
write -host "Hello␣$name.␣␣This␣year␣is␣$year"