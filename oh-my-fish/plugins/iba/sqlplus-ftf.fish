function sqlplus-ftf
  set -l FTF_CONN "FTF/FTF@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=7521))(CONNECT_DATA=(SID=TD153)))"
  sqlplus $FTF_CONN
end
