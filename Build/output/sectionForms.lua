
--[[--------------------------------------------------------------------------------
    -- Forms - Save strings as files in CE autorun\forms directory, then load form
    -- from file.  
    --------------------------------------------------------------------------------]]

local stringFormMonoClass = '[==========<?xml version="1.0" encoding="utf-8"?>
<FormData>
  <formMonoClass Class="TCEForm" Encoding="Ascii85">/yXy*/3td4;=F41+]S%7-9[S)8wjBhaO9R]HoK7}lMsjH2I_C;q!qi^+qxopm3Kfq!%Dma2hhF)$K_poB)7+L@pD3sNsL0}z:4a=UG;#ZcYR(mdDGOi$+A_KIq5#[)I_K?:br(3wCkfdu3o^M89!9((jBx%%y=iJ6B-(nYPGMi$Ck#Es?X+$!/5u))%[]*V/0Sn_D]*;euu6OfUHd].NJnlM6-C+D;Mba;5H#*ag73a,$OUnja:-3$l#)(35%$2*]m9)qDPsQXS1c0DeH_SWBsv6SZ@fxzSYh.H1Z(FLo}x:aiPGcMWM7v7xqZ)MoXslMXSwNgr^o.Cp^kZqPs,q3)P!eU%UNpyU+KW[vyruswDm(ww#GY*tx=;Q4(*hG1QRa5oWWcY0kqQz6DSD^Bn)a%r.#5-DQO4Od)yi?xiIj._{#b%@9JHZ*:zOG[o3MB4Cy#w^)OE[.x71Vw.cJ(8;:?6.a}Xv^4+(C{T8ul4-_c+.@sbx7Azb=]L]=C^HobZ#gIy-FU6bs),YN-Kd)%LG0Afifig/B?9folId7zrQ96Oj*z5:bfY*Ui(Et?N2RPJ#dGqycutI{H9@y%aHVVJ3moIA50;We%DN%v27{1ShM%cJ]g=jve@slmsMYH:O/F#S:sN7sTYE7b09#ToIoxkc=2HfeTHD79Vp[.o+]?0,6AxLMm0{QUG3^aSlNfqgh(PoaL;;9EAa=:k$}yC{Yns-S%w9mk4J,j1_0TVDQM;qYO7BK^#[(rJn]2rGO_L0}[]l]6C_#d.aI5Qime;/MahCwh:6R_rZ($r_HhwCejdzA5,7+u33k*_6pAVE-84a;PB}-](rFG6A$Jcsq9^+Htt*6aytoPle][4GDv=jkG*(Yr_m28iP@LY%,8epQ?!$)P+xX=0Cb,QRz2V)rJ/uT(e;_$D#97eqf5;21=2wU;}lHY%{H3sAjiNCS!F{-oYhZ)bTea^x/mA9U0y@O}Y)unaUkP*cC[cQ53JB^hzP^/J!O6/xwl#5kDq8y?;MLEpzG{?oaK_K1#DDbFRy$6rB%Kv%d@S3-j#KVN6[#GARBEK(s$_psl+drRQL-{w#3Dr/tKKCV1*,y68/g]ehS3BepPvrpw*DHMZT9nZyjZi_GR9^M(6mdLZ[9bx.U0xmAb]E[T_9Stnaqj7xE4^[p.4(2P#n@m!1!TdQr*jeM.;jS]l;H0gGCu4x2/!k4B@7clB?yIMX90FOnK}QE,8(PL=B)*MXj,_)]oqwYN-bx5u58ss)AlVNY]52pc9$=*,1cL=:{6()KZVS?dXKwW)wjb6LWCK3]?Ed.ZS}h4v^F;wgQGlr74wI}KI=_iwxn9i,tma7j53-v12HRRCM29L5Hn7g;.asL@6pL+^1W0B5DyWS88_tiC_[fec7sAQFo#4c%,tJ7in!I@</formMonoClass>
</FormData>
]==========]'

local stringFormMonoImage = '[==========<?xml version="1.0" encoding="utf-8"?>
<FormData>
  <formMonoImage Class="TCEForm" Encoding="Ascii85">#goBu):ZT+Wtl^dlQI).N^(5n(hQF{X^MQJn@1eo5fn$ZHIXe;RtGr4190F.cqtCN1hVAXjWcD*0l3*K^?z^hx4+qE0Ksbh3I+QToQw1+QkP4f?kNSb@5lX/)jLR@IiYbP=eCTy?ZA0ZI(bMlCiZ8DJe+6*v,mF+jD,(E%sth}1CLRX$vU-f(i9$XRV@:QA!q!f%hX+b6)]dyOt_prhLp]G9=zuU40V/tG9sQgs]],Y[?WW7%bqQH*RxO9*We0CaVdE@Zgdl/@M}s?b/WI$4H*R(bICOq:vG*bM5b2J?8GRcx[DbAAiUL]9lSLiz[S=[8zTH1hct@Prs^Avs4E{u#(j9zj(]G[D0JP0B(qo^2%G=}m+ra!0MJv,XL@_ZnSM_HxTV)cJhf9I9+4KLxJqx*H(z;36.k,8JMD^Qkiz#h)TZim?DT^LGY6G3@@j/pDI11cbh0/UjyJR^0G:vZE5TzyieiSvQC;a(0j_I1#Y1q]28AO^@P9DA)8H^GkPRD[5Z%y%t^HKF?{v6g?tUv!E3cP_:l]R+yV4f4v4-{wf!3Qc8fU38JaQy9#^U-{8!JCVHkhj,CSHPtPb3.lul(V3=_gdgp9Os[Rb%_?;C,WXNw,f/6f.*]R#b*wa-.kPtDstrDfs3NGb%qJ6y3fSIFkJp7HU$DGcFw09Lg7,2RjA700</formMonoImage>
</FormData>
]==========]'

local stringFormMonoSearch = '[==========<?xml version="1.0" encoding="utf-8"?>
<FormData>
  <formMonoSearch Class="TCEForm" Encoding="Ascii85">%}#KF,cp%Yq+#;fF0-;[=QS^sGN4#^E)+k6vj(Lgz(5foZ80]sniM43Np}sshx8vPu*}UB$D$ZEpujG;?1GedO3?FSj[d9*9_ZEf$H%Addmm}2)+$66arzA$cAlT_Xuf_XA6=G*0HbI.-8.uu!g/qhUtlts3g:JT8S;Ei8Pt9tftWhe8tkA?5YF5@wd!7n63j#z^fphu@DKC.i]fEtbNTEd!oa?V@#V/Bhcgjz;V/Nw9ABQW?svjc5?1!pqtp+.y:#V{queWtsW_WF(b{)5.y$dp*d;11j?n!ZK7Ww:wZXi1;aQe75VPwUV6PLv=0SmVuvR{A3$n!Ot*VZ[NaGB3,PG0eGa2uqnMwoEEGg1MGo2h9w0RWZXb[==VUtICuU6TZ=Ds_4mZY*khh=iyYS,CX8lABK-]GG6dn)2Tz#q!VV2ZIQ6q=cP;Uo+*pUQ-v+MRD*:K(G;SU(WUA-*kNg7b_GB/BHTpzZr5od4b*DX,(mQ@X]4hvgczwE(1Wz.qx]By8Zz.W:g#F__QU1-}FnoXQ$Iobm_5F;O.co_Rk!?seWbUd3%r10a!Bz0WXhgzBmH-5Hk)z6a%}N^/;fl5exSPS%#XNh:]J%B9xI+R]yBwpGPCTI,4R#Pp0w%_dUq;=0E6KpT4tA(qdfR15HJM.Cc0xAkSUt?Ea@KtuBQUBnk+o8NpsQ3IVqm1=51xRrs;Vu,EiV$kl48LHXD8O%8AYtHPHvp:lb2[,K-T_@VEG6umd%(/dI9OJkQ?v{0-?2%oNq#!.gvA87ox/%zc+P13Wfm_iS0CY9X2zE7acfdDPwv_wxY0$Gv[]S8QP?p]X7IPNwTeo!76BLiXM_13T)T(b^=08,mlCd46yF9SujgZ]d-y)s0ua8mCWAvr)[xZIv4*Iv^1:4(*mOk;lW!%RhkA(M{YArlk.ZT_D)mSHE3(u0{*oMiQ0:gXrAtge{xEZT}juan)rM/p@=flG1K=H?9x;+oPf}?^}@p_B(!z)9MgNLZ?=lpQ=Nm;=0zbuSbPL8o%I)u4$rs_R*pm/9t,@qTwUA;i7_NGrqc25bWK{E[;%N4(fO1YVntn-,Zyz$kFT3!t[s)CeZcRlY6^jH+)mKFW)QxsiGz{zh6UjZmANF/heJ][E!^JSH[[(+c:VU:-Z-Js}=Ww+rATHnTN6/yR#vp]/5-)7vMT_LeRLqX1OmibihP8Na;$dB01?5=S0Q,_iY-dfdTVa/J,CNimP1qg%4R@p5r]*Fv+65CYVE)({5DGGBnlK*GI9j*-4YE1q7q58U3AL02oxU_XPnZR;6Cuei?U3y#F!)=6vIY;ivP37p%9%{2cUL:3?.RO#Dp.},_RHO7Rhdq]!V5=_NOohGtZ16ZQNKKC*gLP3*Dp5}V1@*s</formMonoSearch>
</FormData>
]==========]'

local function saveForm(name, text)
    local path = getCheatEngineDir()..[[\autorun\forms\]]..name
    local f, err = io.open(path, "w")
    if f == nil then return nil, err end
    f:write(text)
    f:close()
    return true
end

saveForm('formMonoClass.frm', stringFormMonoClass)
saveForm('formMonoImage.frm', stringFormMonoImage)
saveForm('formMonoSearch.frm', stringFormMonoSearch)

-- set globals for use in lua
formMonoClass = createFormFromFile(getCheatEngineDir()..[[\autorun\forms\formMonoClass.frm]])
formMonoImage = createFormFromFile(getCheatEngineDir()..[[\autorun\forms\formMonoImage.frm]])
formMonoSearch = createFormFromFile(getCheatEngineDir()..[[\autorun\forms\formMonoSearch.frm]])

