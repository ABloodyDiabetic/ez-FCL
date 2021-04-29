var freeaps_determineBasal;(()=>{var e={5546:(e,r,a)=>{var t=a(6880);function n(e,r){r||(r=0);var a=Math.pow(10,r);return Math.round(e*a)/a}function o(e,r){return"mmol/L"===r.out_units?n(e/18,1).toFixed(1):Math.round(e)}e.exports=function(e,r,a,s,i,l,m,u,d,c){var p={},h=new Date;if(c&&(h=c),void 0===s||void 0===s.current_basal)return p.error="Error: could not get current basal rate",p;var g=t(s.current_basal,s),f=g,b=new Date;c&&(b=c);var B=new Date(e.date),v=n((b-B)/60/1e3,1),M=e.glucose,x=e.noise;if((M<=10||38===M||x>=3)&&(p.reason="CGM is calibrating, in ??? state, or noise is high"),v>12||v<-5?p.reason="If current system time "+b+" is correct, then BG data is too old. The last BG data was read "+v+"m ago at "+B:M>60&&0==e&&e.short_avgdelta>-1&&e.short_avgdelta<1&&e.long_avgdelta>-1&&e.long_avgdelta<1&&(e.last_cal&&e.last_cal<3?p.reason="CGM was just calibrated":p.reason="Error: CGM data is unchanged for the past ~45m"),M<=10||38===M||x>=3||v>12||v<-5||M>60&&0==e&&e.short_avgdelta>-1&&e.short_avgdelta<1&&e.long_avgdelta>-1&&e.long_avgdelta<1)return r.rate>f?(p.reason+=". Replacing high temp basal of "+r.rate+" with neutral temp of "+f,p.deliverAt=h,p.temp="absolute",p.duration=30,p.rate=f,p):0===r.rate&&r.duration>30?(p.reason+=". Shortening "+r.duration+"m long zero temp to 30m. ",p.deliverAt=h,p.temp="absolute",p.duration=30,p.rate=0,p):(p.reason+=". Temp "+r.rate+" <= current basal "+f+"U/hr; doing nothing. ",p);var _,G,C,w,S=s.max_iob;if(void 0!==s.min_bg&&(G=s.min_bg),void 0!==s.max_bg&&(C=s.max_bg),void 0===s.min_bg||void 0===s.max_bg)return p.error="Error: could not determine target_bg. ",p;_=(s.min_bg+s.max_bg)/2;var O=s.exercise_mode||s.high_temptarget_raises_sensitivity,y=100;if(s.half_basal_exercise_target)var T=s.half_basal_exercise_target;else T=160;if(O&&s.temptargetSet&&_>y||s.low_temptarget_lowers_sensitivity&&s.temptargetSet&&_<y){var A=T-y;w=A/(A+_-y),w=n(w=Math.min(w,s.autosens_max),2),process.stderr.write("Sensitivity ratio set to "+w+" based on temp target of "+_+"; ")}else void 0!==i&&i&&(w=i.ratio,process.stderr.write("Autosens ratio: "+w+"; "));if(w&&(f=s.current_basal*w,(f=t(f,s))!==g?process.stderr.write("Adjusting basal from "+g+" to "+f+"; "):process.stderr.write("Basal unchanged: "+f+"; ")),s.temptargetSet);else if(void 0!==i&&i&&(s.sensitivity_raises_target&&i.ratio<1||s.resistance_lowers_target&&i.ratio>1)){G=n((G-60)/i.ratio)+60,C=n((C-60)/i.ratio)+60;var U=n((_-60)/i.ratio)+60;_===(U=Math.max(80,U))?process.stderr.write("target_bg unchanged: "+U+"; "):process.stderr.write("target_bg from "+_+" to "+U+"; "),_=U}if(void 0===a)return p.error="Error: iob_data undefined. ",p;var j,D=a;if(a.length,a.length>1&&(a=D[0]),void 0===a.activity||void 0===a.iob)return p.error="Error: iob_data missing some property. ",p;j=e.delta>-.5?"+"+n(e.delta,0):n(e.delta,0);var I,E=Math.min(e.delta,e.short_avgdelta),F=Math.min(e.short_avgdelta,e.long_avgdelta),q=Math.max(e.delta,e.short_avgdelta,e.long_avgdelta),W=n(s.sens,1),R=s.sens;void 0!==i&&i&&((R=n(R=s.sens/w,1))!==W?process.stderr.write("ISF from "+W+" to "+R):process.stderr.write("ISF unchanged: "+R)),console.error("; CR:",s.carb_ratio);var z=((I=void 0!==a.lastTemp?n((new Date(b).getTime()-a.lastTemp.date)/6e4):0)+r.duration)%30;if(console.error("currenttemp:",r,"lastTempAge:",I,"m","tempModulus:",z,"m"),p.temp="absolute",p.deliverAt=h,u&&r&&a.lastTemp&&r.rate!==a.lastTemp.rate&&I>10&&r.duration)return p.reason="Warning: currenttemp rate "+r.rate+" != lastTemp rate "+a.lastTemp.rate+" from pumphistory; canceling temp",m.setTempBasal(0,0,s,p,r);if(r&&a.lastTemp&&r.duration>0){var k=I-a.lastTemp.duration;if(k>5&&I>10)return p.reason="Warning: currenttemp running but lastTemp from pumphistory ended "+k+"m ago; canceling temp",m.setTempBasal(0,0,s,p,r)}var L=n(-a.activity*R*5,2),P=n(6*(E-L));if(P<0&&(P=n(6*(F-L)))<0&&(P=n(6*(e.long_avgdelta-L))),a.iob>0)var N=n(M-a.iob*R);else N=n(M-a.iob*Math.min(R,s.sens));var Z=N+P;if(e.noise>=2){var $=Math.max(1.1,s.noisyCGMTargetMultiplier),H=(Math.min(250,s.maxRaw),n(Math.min(200,G*$))),J=n(Math.min(200,_*$)),K=n(Math.min(200,C*$));process.stderr.write("Raising target_bg for noisy / raw CGM data, from "+_+" to "+J+"; "),G=H,_=J,C=K}else M>C&&s.adv_target_adjustments&&!s.temptargetSet&&(H=n(Math.max(80,G-(M-G)/3),0),J=n(Math.max(80,_-(M-_)/3),0),K=n(Math.max(80,C-(M-C)/3),0),Z>H&&N>H&&G>H?(process.stderr.write("Adjusting targets for high BG: min_bg from "+G+" to "+H+"; "),G=H):process.stderr.write("min_bg unchanged: "+G+"; "),Z>J&&N>J&&_>J?(process.stderr.write("target_bg from "+_+" to "+J+"; "),_=J):process.stderr.write("target_bg unchanged: "+_+"; "),Z>K&&N>K&&C>K?(console.error("max_bg from "+C+" to "+K),C=K):console.error("max_bg unchanged: "+C));var Q=function(e,r,a){return n(a+(e-r)/24,1)}(_,Z,L);if(void 0===Z||isNaN(Z))return p.error="Error: could not calculate eventualBG. ",p;var V=G-.5*(G-40);p={temp:"absolute",bg:M,tick:j,eventualBG:Z,insulinReq:0,reservoir:d,deliverAt:h,sensitivityRatio:w};var X=[],Y=[],ee=[],re=[],ae=[];X.push(M),Y.push(M),ee.push(M),ae.push(M),re.push(M);var te=function(e,r,a,t){return r?!e.allowSMB_with_high_temptarget&&e.temptargetSet&&t>100?(console.error("SMB disabled due to high temptarget of",t),!1):!0===a.bwFound&&!1===e.A52_risk_enable?(console.error("SMB disabled due to Bolus Wizard activity in the last 6 hours."),!1):!0===e.enableSMB_always?(a.bwFound?console.error("Warning: SMB enabled within 6h of using Bolus Wizard: be sure to easy bolus 30s before using Bolus Wizard"):console.error("SMB enabled due to enableSMB_always"),!0):!0===e.enableSMB_with_COB&&a.mealCOB?(a.bwCarbs?console.error("Warning: SMB enabled with Bolus Wizard carbs: be sure to easy bolus 30s before using Bolus Wizard"):console.error("SMB enabled for COB of",a.mealCOB),!0):!0===e.enableSMB_after_carbs&&a.carbs?(a.bwCarbs?console.error("Warning: SMB enabled with Bolus Wizard carbs: be sure to easy bolus 30s before using Bolus Wizard"):console.error("SMB enabled for 6h after carb entry"),!0):!0===e.enableSMB_with_temptarget&&e.temptargetSet&&t<100?(a.bwFound?console.error("Warning: SMB enabled within 6h of using Bolus Wizard: be sure to easy bolus 30s before using Bolus Wizard"):console.error("SMB enabled for temptarget of",o(t,e)),!0):(console.error("SMB disabled (no enableSMB preferences active or no condition satisfied)"),!1):(console.error("SMB disabled (!microBolusAllowed)"),!1)}(s,u,l,_),ne=s.enableUAM,oe=0,se=0;oe=n(E-L,1);var ie=n(E-L,1);csf=R/s.carb_ratio,console.error("profile.sens:",s.sens,"sens:",R,"CSF:",csf);var le=n(30*csf*5/60,1);oe>le&&(console.error("Limiting carb impact from",oe,"to",le,"mg/dL/5m (",30,"g/h )"),oe=le);var me=3;w&&(me/=w);var ue=me;if(l.carbs){me=Math.max(me,l.mealCOB/20);var de=n((new Date(b).getTime()-l.lastCarbTime)/6e4),ce=(l.carbs-l.mealCOB)/l.carbs;ue=n(ue=me+1.5*de/60,1),console.error("Last carbs",de,"minutes ago; remainingCATime:",ue,"hours;",n(100*ce)+"% carbs absorbed")}var pe=Math.max(0,oe/5*60*ue/2)/csf,he=90,ge=1;s.remainingCarbsCap&&(he=Math.min(90,s.remainingCarbsCap)),s.remainingCarbsFraction&&(ge=Math.min(1,s.remainingCarbsFraction));var fe=1-ge,be=Math.max(0,l.mealCOB-pe-l.carbs*fe),Be=(be=Math.min(he,be))*csf*5/60/(ue/2),ve=n(l.slopeFromMaxDeviation,2),Me=n(l.slopeFromMinDeviation,2),xe=Math.min(ve,-Me/3);se=0===oe?0:Math.min(60*ue/5/2,Math.max(0,l.mealCOB*csf/oe));var _e=Math.max(0,l.mealCOB*csf/10);console.error("Carb Impact:",oe,"mg/dL per 5m; CI Duration:",n(5*se/60*2,1),"hours; remaining CI (~2h peak):",n(Be,1),"mg/dL per 5m");var Ge,Ce,we,Se,Oe,ye=999,Te=999,Ae=999,Ue=M,je=999,De=999,Ie=999,Ee=999,Fe=Z,qe=M,We=M,Re=0,ze=[],ke=[];try{D.forEach((function(e){var r=n(-e.activity*R*5,2),a=n(-e.iobWithZeroTemp.activity*R*5,2),t=oe*(1-Math.min(1,ee.length/12));Fe=ee[ee.length-1]+r+t;var o=ae[ae.length-1]+a,s=Math.max(0,Math.max(0,oe)*(1-X.length/Math.max(2*se,1))),i=Math.max(0,Math.max(0,10)*(1-X.length/Math.max(2*_e,1))),l=Math.min(X.length,12*ue-X.length),m=Math.max(0,l/(ue/2*12)*Be);s+m,ze.push(n(m,0)),ke.push(n(s,0)),COBpredBG=X[X.length-1]+r+Math.min(0,t)+s+m;var u=Y[Y.length-1]+r+Math.min(0,t)+i,d=Math.max(0,ie+re.length*xe),c=Math.max(0,ie*(1-re.length/Math.max(36,1))),p=Math.min(d,c);p>0&&(Re=n(5*(re.length+1)/60,1)),UAMpredBG=re[re.length-1]+r+Math.min(0,t)+p,ee.length<48&&ee.push(Fe),X.length<48&&X.push(COBpredBG),Y.length<48&&Y.push(u),re.length<48&&re.push(UAMpredBG),ae.length<48&&ae.push(o),COBpredBG<je&&(je=n(COBpredBG)),UAMpredBG<De&&(De=n(UAMpredBG)),Fe<Ie&&(Ie=n(Fe)),o<Ee&&(Ee=n(o));ee.length>18&&Fe<ye&&(ye=n(Fe)),Fe>qe&&(qe=Fe),(se||Be>0)&&X.length>18&&COBpredBG<Te&&(Te=n(COBpredBG)),(se||Be>0)&&COBpredBG>qe&&(We=COBpredBG),ne&&re.length>12&&UAMpredBG<Ae&&(Ae=n(UAMpredBG)),ne&&UAMpredBG>qe&&UAMpredBG}))}catch(e){console.error("Problem with iobArray.  Optional feature Advanced Meal Assist disabled")}l.mealCOB&&(console.error("predCIs (mg/dL/5m):",ke.join(" ")),console.error("remainingCIs:      ",ze.join(" "))),p.predBGs={},ee.forEach((function(e,r,a){a[r]=n(Math.min(401,Math.max(39,e)))}));for(var Le=ee.length-1;Le>12&&ee[Le-1]===ee[Le];Le--)ee.pop();for(p.predBGs.IOB=ee,we=n(ee[ee.length-1]),ae.forEach((function(e,r,a){a[r]=n(Math.min(401,Math.max(39,e)))})),Le=ae.length-1;Le>6&&!(ae[Le-1]>=ae[Le]||ae[Le]<=_);Le--)ae.pop();if(p.predBGs.ZT=ae,n(ae[ae.length-1]),l.mealCOB>0)for(Y.forEach((function(e,r,a){a[r]=n(Math.min(401,Math.max(39,e)))})),Le=Y.length-1;Le>12&&Y[Le-1]===Y[Le];Le--)Y.pop();if(l.mealCOB>0&&(oe>0||Be>0)){for(X.forEach((function(e,r,a){a[r]=n(Math.min(401,Math.max(39,e)))})),Le=X.length-1;Le>12&&X[Le-1]===X[Le];Le--)X.pop();p.predBGs.COB=X,Se=n(X[X.length-1]),Z=Math.max(Z,n(X[X.length-1]))}if(oe>0||Be>0){if(ne){for(re.forEach((function(e,r,a){a[r]=n(Math.min(401,Math.max(39,e)))})),Le=re.length-1;Le>12&&re[Le-1]===re[Le];Le--)re.pop();p.predBGs.UAM=re,Oe=n(re[re.length-1]),re[re.length-1]&&(Z=Math.max(Z,n(re[re.length-1])))}p.eventualBG=Z}console.error("UAM Impact:",ie,"mg/dL per 5m; UAM Duration:",Re,"hours"),ye=Math.max(39,ye),Te=Math.max(39,Te),Ae=Math.max(39,Ae),Ge=n(ye);var Pe=l.mealCOB/l.carbs;Ce=n(Ae<999&&Te<999?(1-Pe)*UAMpredBG+Pe*COBpredBG:Te<999?(Fe+COBpredBG)/2:Ae<999?(Fe+UAMpredBG)/2:Fe),Ee>Ce&&(Ce=Ee),Ue=n(Ue=se||Be>0?ne?Pe*je+(1-Pe)*De:je:ne?De:Ie);var Ne=Ae;if(Ee<V)Ne=(Ae+Ee)/2;else if(Ee<_){var Ze=(Ee-V)/(_-V);Ne=(Ae+(Ae*Ze+Ee*(1-Ze)))/2}else Ee>Ae&&(Ne=(Ae+Ee)/2);if(Ne=n(Ne),l.carbs)if(!ne&&Te<999)Ge=n(Math.max(ye,Te));else if(Te<999){var $e=Pe*Te+(1-Pe)*Ne;Ge=n(Math.max(ye,Te,$e))}else Ge=ne?Ne:Ue;else ne&&(Ge=n(Math.max(ye,Ne)));Ge=Math.min(Ge,Ce),process.stderr.write("minPredBG: "+Ge+" minIOBPredBG: "+ye+" minZTGuardBG: "+Ee),Te<999&&process.stderr.write(" minCOBPredBG: "+Te),Ae<999&&process.stderr.write(" minUAMPredBG: "+Ae),console.error(" avgPredBG:",Ce,"COB:",l.mealCOB,"/",l.carbs),We>M&&(Ge=Math.min(Ge,We)),p.COB=l.mealCOB,p.IOB=a.iob,p.reason="COB: "+l.mealCOB+", Dev: "+o(P,s)+", BGI: "+o(L,s)+", ISF: "+o(R,s)+", CR: "+n(s.carb_ratio,2)+", Target: "+o(_,s)+", minPredBG "+o(Ge,s)+", minGuardBG "+o(Ue,s)+", IOBpredBG "+o(we,s),Se>0&&(p.reason+=", COBpredBG "+o(Se,s)),Oe>0&&(p.reason+=", UAMpredBG "+o(Oe,s)),p.reason+="; ";var He=N;He<40&&(He=Math.min(Ue,He));var Je=V-He,Ke=240,Qe=240;if(l.mealCOB>0&&(oe>0||Be>0)){for(Le=0;Le<X.length;Le++)if(X[Le]<G){Ke=5*Le;break}for(Le=0;Le<X.length;Le++)if(X[Le]<V){Qe=5*Le;break}}else{for(Le=0;Le<ee.length;Le++)if(ee[Le]<G){Ke=5*Le;break}for(Le=0;Le<ee.length;Le++)if(ee[Le]<V){Qe=5*Le;break}}te&&Ue<V&&(console.error("minGuardBG",o(Ue,s),"projected below",o(V,s),"- disabling SMB"),te=!1),q>.2*M&&(console.error("maxDelta",o(q,s),"> 20% of BG",o(M,s),"- disabling SMB"),p.reason+="maxDelta "+o(q,s)+" > 20% of BG "+o(M,s)+": SMB disabled; ",te=!1),console.error("BG projected to remain above",o(G,s),"for",Ke,"minutes"),(Qe<240||Ke<60)&&console.error("BG projected to remain above",o(V,s),"for",Qe,"minutes");var Ve=Qe,Xe=s.current_basal*R*Ve/60,Ye=Math.max(0,l.mealCOB-.25*l.carbs),er=(Je-Xe)/csf-Ye;if(Xe=n(Xe),er=n(er),console.error("naive_eventualBG:",N,"bgUndershoot:",Je,"zeroTempDuration:",Ve,"zeroTempEffect:",Xe,"carbsReq:",er),er>=s.carbsReqThreshold&&Qe<=45&&(p.carbsReq=er,p.reason+=er+" add'l carbs req w/in "+Qe+"m; "),M<V&&a.iob<20*-s.current_basal/60&&E>0&&E>Q)p.reason+="IOB "+a.iob+" < "+n(20*-s.current_basal/60,2),p.reason+=" and minDelta "+o(E,s)+" > expectedDelta "+o(Q,s)+"; ";else if(M<V||Ue<V){p.reason+="minGuardBG "+o(Ue,s)+"<"+o(V,s);var rr=(Je=_-Ue)/R,ar=n(60*rr/s.current_basal);return ar=30*n(ar/30),ar=Math.min(120,Math.max(30,ar)),m.setTempBasal(0,ar,s,p,r)}if(s.skip_neutral_temps&&p.deliverAt.getMinutes()>=55)return p.reason+="; Canceling temp at "+p.deliverAt.getMinutes()+"m past the hour. ",m.setTempBasal(0,0,s,p,r);if(Z<G){if(p.reason+="Eventual BG "+o(Z,s)+" < "+o(G,s),E>Q&&E>0&&!er)return N<40?(p.reason+=", naive_eventualBG < 40. ",m.setTempBasal(0,30,s,p,r)):(e.delta>E?p.reason+=", but Delta "+o(j,s)+" > expectedDelta "+o(Q,s):p.reason+=", but Min. Delta "+E.toFixed(2)+" > Exp. Delta "+o(Q,s),r.duration>15&&t(f,s)===t(r.rate,s)?(p.reason+=", temp "+r.rate+" ~ req "+f+"U/hr. ",p):(p.reason+="; setting current basal of "+f+" as temp. ",m.setTempBasal(f,30,s,p,r)));var tr=2*Math.min(0,(Z-_)/R);tr=n(tr,2);var nr=Math.min(0,(N-_)/R);if(nr=n(nr,2),E<0&&E>Q)tr=n(tr*(E/Q),2);var or=f+2*tr;or=t(or,s);var sr=r.duration*(r.rate-f)/60;if(sr<Math.min(tr,nr)-.3*f)return p.reason+=", "+r.duration+"m@"+r.rate.toFixed(2)+" is a lot less than needed. ",m.setTempBasal(or,30,s,p,r);if(void 0!==r.rate&&r.duration>5&&or>=.8*r.rate)return p.reason+=", temp "+r.rate+" ~< req "+or+"U/hr. ",p;if(or<=0){if((ar=n(60*(rr=(Je=_-N)/R)/s.current_basal))<0?ar=0:(ar=30*n(ar/30),ar=Math.min(120,Math.max(0,ar))),ar>0)return p.reason+=", setting "+ar+"m zero temp. ",m.setTempBasal(or,ar,s,p,r)}else p.reason+=", setting "+or+"U/hr. ";return m.setTempBasal(or,30,s,p,r)}if(E<Q&&(!u||!te))return e.delta<E?p.reason+="Eventual BG "+o(Z,s)+" > "+o(G,s)+" but Delta "+o(j,s)+" < Exp. Delta "+o(Q,s):p.reason+="Eventual BG "+o(Z,s)+" > "+o(G,s)+" but Min. Delta "+E.toFixed(2)+" < Exp. Delta "+o(Q,s),r.duration>15&&t(f,s)===t(r.rate,s)?(p.reason+=", temp "+r.rate+" ~ req "+f+"U/hr. ",p):(p.reason+="; setting current basal of "+f+" as temp. ",m.setTempBasal(f,30,s,p,r));if(Math.min(Z,Ge)<C&&(!u||!te))return p.reason+=o(Z,s)+"-"+o(Ge,s)+" in range: no temp required",r.duration>15&&t(f,s)===t(r.rate,s)?(p.reason+=", temp "+r.rate+" ~ req "+f+"U/hr. ",p):(p.reason+="; setting current basal of "+f+" as temp. ",m.setTempBasal(f,30,s,p,r));if(Z>=C&&(p.reason+="Eventual BG "+o(Z,s)+" >= "+o(C,s)+", "),a.iob>S)return p.reason+="IOB "+n(a.iob,2)+" > max_iob "+S,r.duration>15&&t(f,s)===t(r.rate,s)?(p.reason+=", temp "+r.rate+" ~ req "+f+"U/hr. ",p):(p.reason+="; setting current basal of "+f+" as temp. ",m.setTempBasal(f,30,s,p,r));(tr=n((Math.min(Ge,Z)-_)/R,2))>S-a.iob&&(p.reason+="max_iob "+S+", ",tr=S-a.iob),or=t(or=f+2*tr,s),tr=n(tr,3),p.insulinReq=tr;var ir=n((new Date(b).getTime()-a.lastBolusTime)/6e4,1);if(u&&te&&M>V){var lr=n(l.mealCOB/s.carb_ratio,3);if(void 0===s.maxSMBBasalMinutes){var mr=n(30*s.current_basal/60,1);console.error("profile.maxSMBBasalMinutes undefined: defaulting to 30m")}else a.iob>lr&&a.iob>0?(console.error("IOB",a.iob,"> COB",l.mealCOB+"; mealInsulinReq =",lr),s.maxUAMSMBBasalMinutes?(console.error("profile.maxUAMSMBBasalMinutes:",s.maxUAMSMBBasalMinutes,"profile.current_basal:",s.current_basal),mr=n(s.current_basal*s.maxUAMSMBBasalMinutes/60,1)):(console.error("profile.maxUAMSMBBasalMinutes undefined: defaulting to 30m"),mr=n(30*s.current_basal/60,1))):(console.error("profile.maxSMBBasalMinutes:",s.maxSMBBasalMinutes,"profile.current_basal:",s.current_basal),mr=n(s.current_basal*s.maxSMBBasalMinutes/60,1));var ur=1/s.bolus_increment,dr=Math.floor(Math.min(tr/2,mr)*ur)/ur;ar=n(60*(rr=(_-(N+ye)/2)/R)/s.current_basal),tr>0&&dr<s.bolus_increment&&(ar=0);var cr=0;ar<=0?ar=0:ar>=30?(ar=30*n(ar/30),ar=Math.min(60,Math.max(0,ar))):(cr=n(f*ar/30,2),ar=30),p.reason+=" insulinReq "+tr,dr>=mr&&(p.reason+="; maxBolus "+mr),ar>0&&(p.reason+="; setting "+ar+"m low temp of "+cr+"U/h"),p.reason+=". ";var pr=3;s.SMBInterval&&(pr=Math.min(10,Math.max(1,s.SMBInterval)));var hr=n(pr-ir,0),gr=n(60*(pr-ir),0)%60;if(console.error("naive_eventualBG",N+",",ar+"m "+cr+"U/h temp needed; last bolus",ir+"m ago; maxBolus: "+mr),ir>pr?dr>0&&(p.units=dr,p.reason+="Microbolusing "+dr+"U. "):p.reason+="Waiting "+hr+"m "+gr+"s to microbolus again. ",ar>0)return p.rate=cr,p.duration=ar,p}var fr=m.getMaxSafeBasal(s);return or>fr&&(p.reason+="adj. req. rate: "+or+" to maxSafeBasal: "+fr+", ",or=t(fr,s)),(sr=r.duration*(r.rate-f)/60)>=2*tr?(p.reason+=r.duration+"m@"+r.rate.toFixed(2)+" > 2 * insulinReq. Setting temp basal of "+or+"U/hr. ",m.setTempBasal(or,30,s,p,r)):void 0===r.duration||0===r.duration?(p.reason+="no temp, setting "+or+"U/hr. ",m.setTempBasal(or,30,s,p,r)):r.duration>5&&t(or,s)<=t(r.rate,s)?(p.reason+="temp "+r.rate+" >~ req "+or+"U/hr. ",p):(p.reason+="temp "+r.rate+"<"+or+"U/hr. ",m.setTempBasal(or,30,s,p,r))}},6880:(e,r,a)=>{var t=a(6654);e.exports=function(e,r){var a=20;void 0!==r&&"string"==typeof r.model&&(t(r.model,"54")||t(r.model,"23"))&&(a=40);return e<1?Math.round(e*a)/a:e<10?Math.round(20*e)/20:Math.round(10*e)/10}},2705:(e,r,a)=>{var t=a(5639).Symbol;e.exports=t},9932:e=>{e.exports=function(e,r){for(var a=-1,t=null==e?0:e.length,n=Array(t);++a<t;)n[a]=r(e[a],a,e);return n}},9750:e=>{e.exports=function(e,r,a){return e==e&&(void 0!==a&&(e=e<=a?e:a),void 0!==r&&(e=e>=r?e:r)),e}},4239:(e,r,a)=>{var t=a(2705),n=a(9607),o=a(2333),s=t?t.toStringTag:void 0;e.exports=function(e){return null==e?void 0===e?"[object Undefined]":"[object Null]":s&&s in Object(e)?n(e):o(e)}},531:(e,r,a)=>{var t=a(2705),n=a(9932),o=a(1469),s=a(3448),i=t?t.prototype:void 0,l=i?i.toString:void 0;e.exports=function e(r){if("string"==typeof r)return r;if(o(r))return n(r,e)+"";if(s(r))return l?l.call(r):"";var a=r+"";return"0"==a&&1/r==-Infinity?"-0":a}},7561:(e,r,a)=>{var t=a(7990),n=/^\s+/;e.exports=function(e){return e?e.slice(0,t(e)+1).replace(n,""):e}},1957:(e,r,a)=>{var t="object"==typeof a.g&&a.g&&a.g.Object===Object&&a.g;e.exports=t},9607:(e,r,a)=>{var t=a(2705),n=Object.prototype,o=n.hasOwnProperty,s=n.toString,i=t?t.toStringTag:void 0;e.exports=function(e){var r=o.call(e,i),a=e[i];try{e[i]=void 0;var t=!0}catch(e){}var n=s.call(e);return t&&(r?e[i]=a:delete e[i]),n}},2333:e=>{var r=Object.prototype.toString;e.exports=function(e){return r.call(e)}},5639:(e,r,a)=>{var t=a(1957),n="object"==typeof self&&self&&self.Object===Object&&self,o=t||n||Function("return this")();e.exports=o},7990:e=>{var r=/\s/;e.exports=function(e){for(var a=e.length;a--&&r.test(e.charAt(a)););return a}},6654:(e,r,a)=>{var t=a(9750),n=a(531),o=a(554),s=a(9833);e.exports=function(e,r,a){e=s(e),r=n(r);var i=e.length,l=a=void 0===a?i:t(o(a),0,i);return(a-=r.length)>=0&&e.slice(a,l)==r}},1469:e=>{var r=Array.isArray;e.exports=r},3218:e=>{e.exports=function(e){var r=typeof e;return null!=e&&("object"==r||"function"==r)}},7005:e=>{e.exports=function(e){return null!=e&&"object"==typeof e}},3448:(e,r,a)=>{var t=a(4239),n=a(7005);e.exports=function(e){return"symbol"==typeof e||n(e)&&"[object Symbol]"==t(e)}},8601:(e,r,a)=>{var t=a(4841),n=1/0;e.exports=function(e){return e?(e=t(e))===n||e===-1/0?17976931348623157e292*(e<0?-1:1):e==e?e:0:0===e?e:0}},554:(e,r,a)=>{var t=a(8601);e.exports=function(e){var r=t(e),a=r%1;return r==r?a?r-a:r:0}},4841:(e,r,a)=>{var t=a(7561),n=a(3218),o=a(3448),s=/^[-+]0x[0-9a-f]+$/i,i=/^0b[01]+$/i,l=/^0o[0-7]+$/i,m=parseInt;e.exports=function(e){if("number"==typeof e)return e;if(o(e))return NaN;if(n(e)){var r="function"==typeof e.valueOf?e.valueOf():e;e=n(r)?r+"":r}if("string"!=typeof e)return 0===e?e:+e;e=t(e);var a=i.test(e);return a||l.test(e)?m(e.slice(2),a?2:8):s.test(e)?NaN:+e}},9833:(e,r,a)=>{var t=a(531);e.exports=function(e){return null==e?"":t(e)}}},r={};function a(t){var n=r[t];if(void 0!==n)return n.exports;var o=r[t]={exports:{}};return e[t](o,o.exports,a),o.exports}a.g=function(){if("object"==typeof globalThis)return globalThis;try{return this||new Function("return this")()}catch(e){if("object"==typeof window)return window}}();var t=a(5546);freeaps_determineBasal=t})();
