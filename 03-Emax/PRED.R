PRED = function(THETA, ETAi, DATAi)
{
  CE   = DATAi[,"CE"]
  CE50 = as.numeric(THETA[1] * exp(ETAi[1]))
  BASE = as.numeric(THETA[2])
  F    = BASE * (1 - CE/(CE50 + CE))
  G1   = BASE * CE * CE50 / (CE50 + CE)^2
  H1   = rep(1, nrow(DATAi))
  D11  = (-2*CE50/(CE + CE50) + 1) * G1

  return(cbind(F, G1, H1, D11))
}

