PRED = function(THETA, ETA, DATAi)
{
  FGDres = FGD(THETA[1], THETA[2], THETA[3], ETA[1], ETA[2], ETA[3], DOSE=320, DATAi[,"TIME"])
  Gres = attr(FGDres, "gradient")
  Hres = attr(H(FGDres, 0, 0), "gradient")
  
  if (e$METHOD == "LAPL") {
    Dres = attr(FGDres, "hessian")
    Res = cbind(FGDres, Gres, Hres, Dres[,1,1], Dres[,2,1], Dres[,2,2], Dres[,3,])
    colnames(Res) = c("F", "G1", "G2", "G3", "H1", "H2", "D11", "D21", "D22", "D31", "D32", "D33")
  } else {
    Res = cbind(FGDres, Gres, Hres)
    colnames(Res) = c("F", "G1", "G2", "G3", "H1", "H2")
  }
  return(Res)
}

PRED_old = function(THETA, ETA, DATAi)
{
  DOSE = 320
  TIME = DATAi[,"TIME"]

  KA = THETA[1]*exp(ETA[1])
  V  = THETA[2]*exp(ETA[2])
  K  = THETA[3]*exp(ETA[3])

  TERM1 = DOSE/V * KA/(KA - K)
  TERM2 = exp(-K*TIME)
  TERM3 = exp(-KA*TIME)

  F  = TERM1 * (TERM2 - TERM3)
  G1 = -F*K/(KA - K) + KA*TIME*TERM1*TERM3
  G2 = -F
  G3 = (F/(KA - K) - TIME*TERM1*TERM2) * K
  H1 = F
  H2 = 1

  if (METHOD=="LAPL") {
    D11 = DOSE*(KA*V**-1.0*(-1.0*KA*(-2.0*KA*(-1.0*K+KA)**-3.0*(-1.0*TERM3+TERM2)+KA*TIME*TERM3*(-1.0*K+KA)**-2.0)+-1.0*KA*(-1.0*K+KA)**-2.0*(-1.0*TERM3+TERM2)+KA*TIME*(-1.0*KA*TIME*TERM3*(-1.0*K+KA)**-1.0+-1.0*KA*TERM3*(-1.0*K+KA)**-2.0)+KA*TIME*TERM3*(-1.0*K+KA)**-1.0)+KA*V**-1.0*(-1.0*K+KA)**-1.0*(-1.0*TERM3+TERM2)+2.0*KA*V**-1.0*(-1.0*KA*(-1.0*K+KA)**-2.0*(-1.0*TERM3+TERM2)+KA*TIME*TERM3*(-1.0*K+KA)**-1.0))
    D21 = -G1
    D22 = F
    D31 = DOSE*(KA*V**-1.0*(KA*K*TIME*TERM2*(-1.0*K+KA)**-2.0+K*(-2.0*KA*(-1.0*K+KA)**-3.0*(-1.0*TERM3+TERM2)+KA*TIME*TERM3*(-1.0*K+KA)**-2.0))+KA*V**-1.0*(-1.0*K*TIME*TERM2*(-1.0*K+KA)**-1.0+K*(-1.0*K+KA)**-2.0*(-1.0*TERM3+TERM2)))
    D32 = -G3
    D33 = DOSE*KA*V**-1.0*(-1.0*K*TIME*(-1.0*K*TIME*TERM2*(-1.0*K+KA)**-1.0+K*TERM2*(-1.0*K+KA)**-2.0)+-1.0*K*TIME*TERM2*(-1.0*K+KA)**-1.0+K*(-1.0*K*TIME*TERM2*(-1.0*K+KA)**-2.0+2.0*K*(-1.0*K+KA)**-3.0*(-1.0*TERM3+TERM2))+K*(-1.0*K+KA)**-2.0*(-1.0*TERM3+TERM2))
  } else {
    D11 = 0
    D21 = 0
    D22 = 0
    D31 = 0
    D32 = 0
    D33 = 0
  }

  return(cbind(F, G1, G2, G3, H1, H2, D11, D21, D22, D31, D32, D33))
}

