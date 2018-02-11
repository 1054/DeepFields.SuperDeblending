Pannella et al. 2015
    MP_2013_corr.txt

Skelton et al. 2014
    M3D_2013_corr.txt

Processing code in "goFine.sm"
    set zp_X = zp_3D>0 ? zp_3D : zp_P
    set MassX = zp_3D>0 ? mass3D : massP
    set KtotX = Ktot3D>0 && Ktot3D<40 ? Ktot3D : KtotP
    set distX = dist3D<distP ? dist3D : distP
    set MassX = (MassX-massP)<-1 && abs(zp_P-zp_X)/(1+zp_X)<.2 ? massP : MassX   # Added 30/12/2015 because some 3DHST mass seem errouneously very low, prob low age fit
    set MassX = spez3D>0 && abs(zp_X-spez3D)/(1+(zp_X+spez3D)/2)>.2 && (abs(zp_X-zp_P)/(1+(zp_X+zp_P)/2)<.25 && zp_P>0) ? massP : MassX   # 3DHST-specz wrong, masses wrong
    set MassX = spez3D>0 && abs(zp_X-spez3D)/(1+(zp_X+spez3D)/2)>.2 && !(abs(zp_X-zp_P)/(1+(zp_X+zp_P)/2)<.25 && zp_P>0) ? -1 : MassX
    set zp_X = MassX>12 && zp_X<2 && spezX<0 && spez<=0 ? 0 : zp_X     # these are stars
    set MassX = MassX>12 && zp_X<2 && spezX<0 && spez<=0 ? 1 : MassX     # these are stars
    set starX = (zp_X>0 && zp_P==0 && zp_X<.1 && spezX<=0) || _id==6609 # these are also stars
    set starX = starX || ((spez==0 || spez3D==0) && zp_X>0 && _id!=4865)
    set starX = starX || _id==350 || _id==880 || _id==899 || _id==1342 || _id==1687 || _id==3624 || _id==4119 || _id==7617 || _id==13724 || _id==16411 || _id==18196 || _id==18203 || _id==18262 || _id==18395
    set starX = (z_acs>18 && z_acs<27 && dz_acs>=0 && lg(fw_acs)>.6) ? 0 : starX
    set mch1 = 23.9-2.5*lg(_fch1)
    set colstarX = _fch1>0 && _fch1/_dfch1>5 && dz_acs>=0 && z_acs<33 && db_acs>=0 && b_acs<33 && (z_acs-mch1<1.28/4*(b_acs-z_acs)-1.23)  && (lg(fw_acs))<0.6
    set fwstarX = dz_acs>=0 && z_acs<33 && (lg(fw_acs))<0.6
    set zp_X = starX || colstarX || fwstarX ? 0 : zp_X
    set MassX = starX || colstarX || fwstarX ? 1 : MassX
    set spezX = spez>0 && zq==1 ? spez : -1
    set spezX = spez>0 && (zq==2 || zq==-1) && ( abs(((zp_X-spez)/(1+spez)))<.1 || zp_X<0) ? spez : spezX
    set spezX = (zq>2 || zq<-1) && spez3D>0 && ( abs(((zp_X-spez3D)/(1+spez3D)))<.1 || zp_X<0) ? spez3D : spezX
    set goodArea = noi24<0.006 
    set dist = sqrt(((raF-189.20958)*3600*cosd(62.2))**2+((deF-62.206944)*3600)**2) set coo = dist<30


