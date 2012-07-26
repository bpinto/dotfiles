function sqlplus-crp
  set -l CRP_CONN "ESS_USER/ESS_USER@//localhost:6521/TH154"
  sqlplus $CRP_CONN
end
