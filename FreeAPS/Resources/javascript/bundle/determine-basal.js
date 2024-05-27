var freeaps_determineBasal;(()=>{var e={2982:(e,r,a)=>{var t=a(3531);function o(e,r){r||(r=0);var a=Math.pow(10,r);return Math.round(e*a)/a}function n(e,r){return"mmol/L"===r.out_units?o(.0555*e,1):Math.round(e)}e.exports=function(e,r,a,i,s,l,d,u,m,c,_,p,f,b,g){var h=0,B="",v="",M="",x="",S="",y=0,I=0,T=0,w=0,F=0,D=0;const C=b.tddYtd,O=b.tdd7d,G=b.hbt,U=b.isEnabled,A=e.avgdelta;function z(e,r){var a=e.getTime();return new Date(a+36e5*r)}function R(e){var r=i.bolus_increment;.025!=r&&(r=.05);var a=e/r;return a>=1?o(Math.floor(a)*r,5):0}function P(e){function r(e){return e<10&&(e="0"+e),e}return r(e.getHours())+":"+r(e.getMinutes())+":00"}function E(e,r){var a=new Date("1/1/1999 "+e),t=new Date("1/1/1999 "+r);return(a.getTime()-t.getTime())/36e5}function k(e,r){var a=0,t=r,o=(e-r)/36e5,n=0,i=o,s=0;do{if(o>0){var l=P(t);f[0].rate;for(let e=0;e<f.length;e++){var d=f[e].start;if(l==d){if(e+1<f.length){o>=(s=E(f[e+1].start,f[e].start))?n=s:o<s&&(n=o)}else if(e+1==f.length){let r=f[0].start;o>=(s=24-E(f[e].start,r))?n=s:o<s&&(n=o)}a+=R(f[e].rate*n),o-=n,t=z(t,n)}else if(l>d)if(e+1<f.length){var u=f[e+1].start;l<u&&(o>=(s=E(u,l))?n=s:o<s&&(n=o),a+=R(f[e].rate*n),o-=n,t=z(t,n))}else if(e==f.length-1){o>=(s=E("23:59:59",l))?n=s:o<s&&(n=o),a+=R(f[e].rate*n),o-=n,t=z(t,n)}}}}while(o>0&&o<i);return a}if(_.length){let e=_.length-1;var L=new Date(_[e].timestamp),j=new Date(_[0].timestamp);if("TempBasalDuration"==_[0]._type&&(j=new Date),(h=(j-L)/36e5)<23.9&&h>21)F=k(L,(q=24-h,W=L.getTime(),new Date(W-36e5*q))),x="24 hours of data is required for an accurate tdd calculation. Currently only "+h.toPrecision(3)+" hours of pump history data are available. Using your pump scheduled basals to fill in the missing hours. Scheduled basals added: "+F.toPrecision(5)+" U. ";else x=""}else console.log("Pumphistory is empty!"),dynISFenabled=!1,enableDynamicCR=!1;var q,W,H=0,N=0;o((new Date(Ue).getTime()-l.lastBolusNormalTime)/6e4,1);for(let e=0;e<_.length;e++)if("Bolus"==_[e]._type&&(w+=_[e].amount,0==H&&_[e].amount>=i.iTime_Start_Bolus)){H=t(_[e].amount,i);var X=new Date(_[e].timestamp);N=o((new Date-X)/36e5*60)}for(let e=1;e<_.length;e++)if("TempBasal"==_[e]._type&&_[e].rate>0){y=e,D=_[e].rate;var Y=_[e-1]["duration (min)"]/60,V=Y,Z=new Date(_[e-1].timestamp),$=Z;do{if(e--,0==e){$=new Date;break}if("TempBasal"==_[e]._type||"PumpSuspend"==_[e]._type){$=new Date(_[e].timestamp);break}}while(e>0);var J=($-Z)/36e5;J<V&&(Y=J),T+=R(D*Y),e=y}for(let e=0;e<_.length;e++)if(0,0==_[e]["duration (min)"]||"PumpResume"==_[e]._type){let r=new Date(_[e].timestamp),a=r,t=e;do{if(t>0&&(--t,"TempBasal"==_[t]._type)){a=new Date(_[t].timestamp);break}}while(t>0);(a-r)/36e5>0&&(F+=k(a,r))}for(let e=_.length-1;e>0;e--)if("TempBasalDuration"==_[e]._type){let r=_[e]["duration (min)"]/60,a=new Date(_[e].timestamp);var K=a;let t=e;do{if(--t,t>=0&&("TempBasal"==_[t]._type||"PumpSuspend"==_[t]._type)){K=new Date(_[t].timestamp);break}}while(t>0);if(0==e&&"TempBasalDuration"==_[0]._type&&(K=new Date,r=_[e]["duration (min)"]/60),(K-a)/36e5-r>0){F+=k(K,z(a,r))}}var Q={TDD:o(I=w+T+F,5),bolus:o(w,5),temp_basal:o(T,5),scheduled_basal:o(F,5)},ee=re(i);function re(e){return 0==I?e.twentyFourHrTDDPlaceholder:I}function ae(e,r){const a=e.isfSlope*re(e)+e.isfIntercept;return e.use_autosens_isf_to_calculate_auto_isf_sens?a:e.sens}function te(e,r){const a=e.current_basal;if(e.use_autosens_isf_to_calculate_auto_isf_sens){let r=e.basalSlope*re(e)+e.basalIntercept;return r=Math.max(0,.05*Math.round(r*e.basal_multiplier/.05)),r}return a}function oe(e,r,a){const t=r.glucose;if(e.enable_max_iob_deadbands){const r=e.tight_deadband_range/100*a+a,o=e.loose_deadband_range/100*a+a;if(t>=0&&t<r&&!e.moderate_carb_ez_fcl_profile&&!e.high_carb_ez_fcl_profile)return e.max_iob_tight_deadband/100*re(e);if(t>=r&&t<=o&&!e.moderate_carb_ez_fcl_profile&&!e.high_carb_ez_fcl_profile)return e.max_iob_loose_deadband/100*re(e);if(t>=r&&e.sleep_mode)return e.max_iob_tight_deadband/100*re(e);if(t>=r&&e.automatic_sleep_mode)return e.max_iob_tight_deadband/100*re(e)}return e.max_iob/100*function(e){return 0==I?e.sevenDayTDDPlaceholder:O}(e)}h>21?(v=". Bolus insulin: "+w.toPrecision(5)+" U",M=". Temporary basal insulin: "+T.toPrecision(5)+" U",B=". Insulin with scheduled basal rate: "+F.toPrecision(5)+" U",S=x+(" TDD past 24h is: "+I.toPrecision(5)+" U")+v+M+B,tddReason=", TDD, 24h: "+o(I,1)+", ytd: "+o(C,1)+", 7dØ: "+o(O,1),console.error(S)):tddReason=", TDD: Not enough pumpData (< 21h)";var ne="",ie="",se="",le="",de="",ue="",me="",ce="",_e="",pe="",fe="",be="",ge="",he=1,Be=1,ve=1,Me=1,xe=1,Se=1,ye=100;function Ie(e,r,a){"bg"==a?(polyX=[50,60,80,90,100,110,150,180,200],polyY=[-.5,-.5,-.3,-.2,0,0,.5,.7,.7]):"delta"==a&&(polyX=[2,7,12,16,20],polyY=[0,0,.4,.7,.7]);var t=polyX.length-1,o=polyX[0],n=polyY[0],i=polyX[t],s=polyY[t],l=1,d=1,u=1,m=o;if(o>e)i=polyX[1],l=(d=n)+((s=polyY[1])-d)/(i-(u=o))*(e-u);else if(i<e)o=polyX[t-1],l=(d=n=polyY[t-1])+(s-d)/(i-(u=o))*(e-u);else for(var c=0;c<=t;c++){if(o=polyX[c],n=polyY[c],o==e){l=n;break}if(o>e){l=d+(n-d)/(o-(u=m))*(e-u);break}d=n,m=o}return l*="delta"==a?r.delta_ISFrange_weight:e>100?r.higher_ISFrange_weight:r.lower_ISFrange_weight}function Te(e,r,a,t,n,i,s,l,d){console.error("check ratio "+o(e,2)+" against autoISF min: "+r+" and autoISF max: "+a),e<r?(_e=" (lmtd.min)",me="weakest autoISF factor "+o(e,2)+" limited by autoISF_min "+r,console.error(me),e=r):e>a&&(_e=" (lmtd.max)",me="strongest autoISF factor "+o(e,2)+" limited by autoISF_max "+a,console.error(me),e=a);var u=1;return s&&i.temptargetSet&&l>d?(u=e*t,n=" (exerciseMode)",console.error("autoISF adjusts sens "+t+", instead of getSensValue(profile) "+ae(i)),pe=n):e>=1?(u=Math.max(e,t),e>=t&&(n="")):(u=Math.min(e,t),e<=t&&(n="")),me="final ISF factor "+o(u,2)+n,console.error(me),u}var we={},Fe=0,De=0,Ce=new Date;if(c&&(Ce=new Date(c)),void 0===i||void 0===te(i))return we.error="Error: could not get current basal rate",we;var Oe=t(te(i),i),Ge=Oe,Ue=new Date;c&&(Ue=new Date(c));var Ae,ze=new Date(e.date),Re=o((Ue-ze)/60/1e3,1),Pe=e.glucose,Ee=e.noise;Ae=n(e.delta,i);var ke=Math.min(e.delta,e.short_avgdelta),Le=Math.min(e.short_avgdelta,e.long_avgdelta),je=Math.max(e.delta,e.short_avgdelta,e.long_avgdelta);(Pe<=10||38===Pe||Ee>=3)&&(we.reason="CGM is calibrating, in ??? state, or noise is high");if(Re>12||Re<-5?we.reason="If current system time "+Ue+" is correct, then BG data is too old. The last BG data was read "+Re+"m ago at "+ze:Pe>60&&e.cgmFlatMinutes>89&&e.last_cal&&e.last_cal<3&&(we.reason="CGM was just calibrated"),Pe<=10||38===Pe||Ee>=3||Re>12||Re<-5||Pe>60&&e.cgmFlatMinutes>89||0===e.short_avgdelta&&0===e.long_avgdelta)return r.rate>Ge?(we.reason+=". Replacing high temp basal of "+r.rate+" with neutral temp of "+Ge,we.deliverAt=Ce,we.temp="absolute",we.duration=30,we.rate=Ge,we):0===r.rate&&r.duration>30?(we.reason+=". Shortening "+r.duration+"m long zero temp to 30m. ",we.deliverAt=Ce,we.temp="absolute",we.duration=30,we.rate=0,we):(we.reason+=". Temp "+r.rate+" <= current basal "+o(Ge,2)+"U/hr; doing nothing. ",we);var qe,We,He,Ne;oe(i,e,qe);if(void 0!==i.min_bg&&(We=i.min_bg),void 0!==i.max_bg&&(He=i.max_bg),void 0!==i.enableSMB_high_bg_target&&(Ne=i.enableSMB_high_bg_target),void 0===i.min_bg||void 0===i.max_bg)return we.error="Error: could not determine target_bg. ",we;qe=(i.min_bg+i.max_bg)/2;var Xe=1,Ye="",Ve=i.exercise_mode||i.high_temptarget_raises_sensitivity,Ze=100,$e=160;i.half_basal_exercise_target&&($e=i.half_basal_exercise_target),U&&($e=G);var Je=1;if(Ve&&i.temptargetSet&&qe>Ze||i.low_temptarget_lowers_sensitivity&&i.temptargetSet&&qe<Ze){var Ke=$e-Ze;Xe=Ke*(Ke+qe-Ze)<=0?i.autosens_max:Ke/(Ke+qe-Ze),Je=Xe=o(Xe=Math.min(Xe,i.autosens_max),2),Ye=" from TT modifier",fe+=", Ratio TT: "+Xe,process.stderr.write("Sensitivity ratio set to "+Xe+" based on temp target of "+qe+"; ")}else void 0!==s&&s&&i.enable_autosens&&!i.use_autosens_isf_to_calculate_auto_isf_sens&&(Ye=" from Autosens",ge=", autosens:, "+o(Xe=s.ratio,2),process.stderr.write("Autosens ratio: "+Xe+"; "));var Qe=Je;if(Xe&&(Ge=te(i)*Xe,(Ge=t(Ge,i))!==Oe?process.stderr.write("Adjusting basal from "+Oe+" to "+Ge+"; "):process.stderr.write("Basal unchanged: "+Ge+"; ")),i.temptargetSet);else if(void 0!==s&&s&&(i.sensitivity_raises_target&&s.ratio<1||i.resistance_lowers_target&&s.ratio>1)){We=o((We-60)/s.ratio)+60,He=o((He-60)/s.ratio)+60;var er=o((qe-60)/s.ratio)+60;er=Math.max(80,er),qe===er?process.stderr.write("target_bg unchanged: "+er+"; "):process.stderr.write("target_bg from "+qe+" to "+er+"; "),qe=er}var rr=200,ar=200,tr=200;if(e.noise>=2){var or=Math.max(1.1,i.noisyCGMTargetMultiplier);Math.min(250,i.maxRaw);rr=o(Math.min(200,We*or)),ar=o(Math.min(200,qe*or)),tr=o(Math.min(200,He*or)),process.stderr.write("Raising target_bg for noisy / raw CGM data, from "+qe+" to "+ar+"; "),We=rr,qe=ar,He=tr}var nr=.5;i.smb_threshold_ratio>.5&&i.smb_threshold_ratio<=1&&(nr=i.smb_threshold_ratio);var ir=We-(1-nr)*(We-40);console.log("MB Threshold set to "+nr+" - no MB's applied below "+n(ir,i));var sr=o(ae(i),1),lr=ae(i);void 0!==s&&s&&((lr=o(lr=ae(i)/Xe,1))!==sr?process.stderr.write("ISF from "+n(sr,i)+" to "+n(lr,i)):process.stderr.write("ISF unchanged: "+n(lr,i))),console.error("CR: "+i.carb_ratio),console.error("----------------------------------"),console.error(" start autoISF"),console.error("----------------------------------");var dr=!0,ur=!1,mr=r.rate,cr=i.b30_duration,_r=cr+1;if(console.error("B30 enabled: "+i.use_B30),i.use_B30&&i.use_autoisf){var pr=i.iTime_Start_Bolus,fr=i.iTime_target,br=i.b30_upperBG,gr=i.b30_upperdelta,hr=i.b30_factor,Br=!1;i.temptargetSet&&(Br=!0);var vr=N;0==vr&&(vr=1);var Mr=H;console.error("B30 last bolus above limit of "+pr+"U was "+Mr+"U, "+vr+"m ago"),Mr>=pr&&vr<=cr&&Br&&qe==fr&&(_r=vr,ur=!0,console.error("B30 iTime is running : "+_r+"m because manual bolus ("+Mr+") >= Minimum Start Bolus size ("+pr+") and EatingSoon TT set at "+n(fr,i))),console.error("B30 Activation: "+ur),console.error("B30 TTset: "+Br+", at "+qe+", last Bolus of "+Mr+"U, "+vr+"m ago. iTime remaining: "+(cr-_r)+"m."),ur&&(e.delta<=gr&&Pe<br&&(dr=!1),_r<=cr&&(be="AIMI B30, Temp "+(mr=t(Ge*hr,i))+"U/hr for "+(cr-_r)+"m, "))}var xr=function(r,a,t,i,s){if(void 0===t)return we.error="Error: iob_data undefined. ",we;var l=t;if(t.length,t.length>1&&(t=l[0]),void 0===t.activity||void 0===t.iob)return we.error="Error: iob_data missing some property. ",we;if(!i)return ie=", ezFCL-MB disabled:, B30 running","AIMI B30";if(!r)return"oref";var d=n(a.min_bg,a);if(a.use_autoisf&&a.temptargetSet&&a.enableSMB_EvenOn_OddOff||a.use_autoisf&&a.min_bg==a.max_bg&&a.enableSMB_EvenOn_OddOff_always&&!a.temptargetSet){a.temptargetSet?msgType="TempTarget ":msgType="ProfileTarget ","mmol/L"==a.out_units?(evenTarget=o(10*d,0)%2==0,msgUnits=" has ",msgTail=" decimal"):(evenTarget=d%2==0,msgUnits=" is ",msgTail=" number"),evenTarget?msgEven="even":msgEven="odd",a.iob_threshold_percent<100&&a.iob_threshold_percent>0&&(ye=a.iob_threshold_percent);var u=ye;return evenTarget?0==oe(a,e,qe)?(console.error("MB disabled because of maxIOB=0"),"blocked"):u/100<t.iob/(oe(a,e,qe)*s)?(console.error("iobTH: "+o(u,1)+"%, IOB% of maxIOB at "+o(t.iob/(oe(a,e,qe)*s)*100,1)+"%"),1!=s?(console.error("Full Loop modified maxIOB "+oe(a,e,qe)+" to effectively "+o(oe(a,e,qe)*s,2)+" due to profile % and/or exercise mode"),", effective maxIOB "+o(oe(a,e,qe)*s,2)):", maxIOB "+oe(a,e,qe),ie=", ezFCL-MB disabled:, iobTH exceeded",console.error("MB disabled by Full Loop logic: IOB "+t.iob+" is more than "+u+"% of maxIOB "+oe(a,e,qe)),console.error("Full Loop capped"),"iobTH"):(console.error("MB enabled - "+msgType+d+msgUnits+msgEven+msgTail),d<100?(console.error("iobTH: "+o(u,1)+"%, IOB% of maxIOB at "+o(t.iob/(oe(a,e,qe)*s)*100,1)+"%"),console.error("Loop at full power"),ie=", ezFCL-MB enabled:, even TT","fullLoop"):(console.error("iobTH: "+o(u,1)+"%, IOB% of maxIOB at "+o(t.iob/(oe(a,e,qe)*s)*100,1)+"%"),ie=", ezFCL-MB enabled:, even Target",console.error("Loop at medium power"),"enforced")):(console.error("MB disabled - "+msgType+d+msgUnits+msgEven+msgTail),ie=", ezFCL-MB disabled:, odd Target",console.error("Loop at minimum power"),"blocked")}return console.error("Full Loop disabled"),"oref"}(u,i,a,dr,Qe),Sr=!1;if(u&&"oref"!=xr?("enforced"!=xr&&"fullLoop"!=xr||(Sr=!0),console.error("loop_smb function overriden with autoISF checks, enableMB = "+Sr)):(Sr=function(e,r,a,t,o,i,s){return r?!e.allowSMB_with_high_temptarget&&e.temptargetSet&&o>100?(console.error("MB disabled due to high temptarget of "+o),!1):!0===a.bwFound&&!1===e.A52_risk_enable?(console.error("MB disabled due to Bolus Wizard activity in the last 6 hours."),!1):!0===e.sleep_mode&&e.disable_mb_during_sleep||!0===e.automatic_sleep_mode&&e.disable_mb_during_sleep?(console.error("MB disabled due to sleep mode."),!1):!0===e.enableSMB_always?(a.bwFound?console.error("Warning: MB enabled within 6h of using Bolus Wizard: be sure to easy bolus 30s before using Bolus Wizard"):console.error("MB enabled due to enable MBs"),!0):!0===e.enableSMB_with_COB&&a.mealCOB?(a.bwCarbs?console.error("Warning: MB enabled with Bolus Wizard carbs: be sure to easy bolus 30s before using Bolus Wizard"):console.error("MB enabled for COB of"+a.mealCOB),!0):!0===e.enableSMB_after_carbs&&a.carbs?(a.bwCarbs?console.error("Warning: MB enabled with Bolus Wizard carbs: be sure to easy bolus 30s before using Bolus Wizard"):console.error("MB enabled for 6h after carb entry"),!0):!0===e.enableSMB_with_temptarget&&e.temptargetSet&&o<100?(a.bwFound?console.error("Warning: MB enabled within 6h of using Bolus Wizard: be sure to easy bolus 30s before using Bolus Wizard"):console.error("MB enabled for temptarget of "+n(o,e)),console.error("MB enabled for temptargets with "+n(o,e)),!0):!0===e.enableSMB_high_bg&&null!==i&&t>=i?(console.error("Checking BG to see if High for MB enablement."),console.error("Current BG",t," | High BG ",i),a.bwFound?console.error("Warning: High BG MB enabled within 6h of using Bolus Wizard: be sure to easy bolus 30s before using Bolus Wizard"):console.error("High BG detected. Enabling MB."),!0):(console.error("MB disabled (no enableMB preferences active or no condition satisfied)"),!1):(console.error("MB disabled (!microBolusAllowed)"),!1)}(i,u,l,Pe,qe,Ne),console.error("loop_smb function returns enableMB = "+Sr)),lr=function(e,r,a,t,i,s,l,d,u,m,c,_){if(!t.use_autoisf)return console.error("autoISF disabled in Preferences"),ne+=", autoISF disabled",e;if(t.autoISF_off_Sport&&(t.high_temptarget_raises_sensitivity||t.exercise_mode)&&t.temptargetSet&&a>_)return console.error("autoISF disabled due to exercise"),ne+=", autoISF disabled (exercise)",e;const p=i.dura_p,f=i.delta_pl,b=i.delta_pn,g=i.r_squ,h=i.bg_acceleration,B=i.a_0,v=i.a_1,M=i.a_2,x=i.dura_ISF_minutes,S=i.dura_ISF_average;t.autoISF_min;var y=t.autoISF_max,I=!1,T=e,w=a+10-i.glucose,F=i.pp_debug;if("bg_acceleration: "+o(h,3)+", PF-minutes: "+p+", PF-corr: "+o(g,4)+", PF-nextDelta: "+n(b,t)+", PF-lastDelta: "+n(f,t)+", regular Delta: "+n(i.delta,t),console.error(F),t.enable_BG_acceleration){var D=g;if(0!=M&&D>=.9){var C=-v/2/M*5,O=o(B-C*C/25*M,1);(C=o(C,1))>0&&h<0?(ce="Max of "+n(O,t)+" in "+Math.abs(C)+" min",console.error("Parabolic fit "+ce)):C>0&&h>0?(ce="Min of "+n(O,t)+" in "+Math.abs(C)+" min",console.error("Parabolic fit "+ce),C<=30&&O<a&&(Be=-t.bgBrake_ISF_weight,ce="Low BG soon. bgBrake ISF weight: "+-Be,console.error("Parabolic fit "+ce))):C<0&&h<0?(ce="Max of "+n(O,t)+" "+Math.abs(C)+" min ago",console.error("Parabolic fit "+ce)):C<0&&h>0&&(ce="Min of "+n(O,t)+" "+Math.abs(C)+" min ago",console.error("Parabolic fit "+ce))}if(D<.9)ce="acce-ISF Ratio: "+o(he,2)+" (acce-ISF: 1.0 as "+o(D,2)+"correlation is too low)",console.error("Parabolic fit "+ce),ue+=ce;else{var G=10*(D-.9),U=1;1==Be&&i.glucose<t.target_bg?h>0?(h>1&&(U=.5),Be=t.bgBrake_ISF_weight):h<0&&(Be=t.bgAccel_ISF_weight):1==Be&&(h<0?Be=t.bgBrake_ISF_weight:h>0&&(Be=t.bgAccel_ISF_weight)),(he=1+h*U*Be*G)<0&&(he=.1),console.error(ue+"acce-ISF adaptation is "+o(he,2)),1!=he&&(I=!0,ue+=", acce-ISF Ratio: "+o(he,2)+" ("+ce+")")}}else console.error("autoISF BG accelertion adaption disabled in Preferences");ne+=ie+ue+", autoISF",ve=1+Ie(100-w,t,"bg"),console.error("bg_ISF adaptation is "+o(ve,2));var A=1,z=1;if(ve<1){A=Math.min(ve,he),he>1?(me="bg-ISF adaptation lifted to "+o(A=ve*he,2)+", as BG accelerates already",console.error(me),ne+=", bg-ISF Ratio: "+o(A,2)+"(accel.)"):ne+=", bg-ISF Ratio: "+o(A,2)+"(minimal)";let e=1;const i=A;return e=t.low_carb_ez_fcl_profile?(i-1)*t.low_carb_ez_fcl_profile_multiplier+1:t.moderate_carb_ez_fcl_profile?(i-1)*t.moderate_carb_ez_fcl_profile_multiplier+1:t.high_carb_ez_fcl_profile?(i-1)*t.high_carb_ez_fcl_profile_multiplier+1:i,z=Te(e,t.autoISF_min,y,u,r,t,c,a,_),T=Math.min(720,o(ae(t)/z,1)),ne+=", final Ratio: "+o(z,2)+pe+_e+", final ISF: "+function(e,r){return e.use_autosens_isf_to_calculate_auto_isf_sens?n(e.sens,e)+"→"+n(ae(e),e)+"→"+n(T,e):n(e.sens,e)+"→"+n(T,e)}(t),T}ve>1&&(I=!0,ne+=", bg-ISF Ratio: "+o(ve,2));var R=i.delta,P=new Date,E="";l&&(P=new Date(l)),t.enable_pp_ISF_always||t.pp_ISF_hours>=(P-new Date(s.lastCarbTime))/1e3/3600?deltaType="pp":deltaType="delta",w>0?console.error(deltaType+"_ISF adaptation by-passed as average glucose < "+a+"+10"):i.short_avgdelta<0?console.error(deltaType+"_ISF adaptation by-passed as no rise or too short lived"):"pp"==deltaType?(xe=1+Math.max(0,R*t.pp_ISF_weight),t.enable_pp_ISF_always||(E=", last Meal "+o((P-s.lastCarbTime)/1e3/3600,1)+" hrs ago is within Range of "+t.pp_ISF_hours+" hrs."),console.error("pp_ISF adaptation is "+o(xe,2)+E),le=", Δ-ISF Ratio: "+o(xe,2),1!=xe&&(I=!0)):(Me=Ie(R,t,"delta"),w>-20&&(Me*=.5),Me=1+Me,console.error("delta_ISF adaptation is "+o(Me,2)),de=", Δ-ISF Ratio: "+o(Me,2),1!=Me&&(I=!0));var k=t.dura_ISF_weight;if(s.mealCOB>0&&!t.enableautoisf_with_COB)console.error("dura_ISF by-passed; preferences disabled mealCOB of "+o(s.mealCOB,1));else if(x<10)console.error("dura_ISF by-passed; BG is only "+x+"m at level "+S);else if(S<=a)console.error("dura_ISF by-passed; avg. glucose "+S+" below target "+n(a,t));else{I=!0,se="--- ISF Ratio: "+o(Se+=x/60*(k/a)*(S-a),2)+"(Duration: "+x+" Avg BG: "+n(S,t)+", ",console.error("dura_ISF adaptation is "+o(Se,2)+" because ISF "+e+" did not do it for "+o(x,1)+"m")}if(I){A=Math.max(Se,ve,Me,he,xe),console.error("autoISF adaption ratios:"),console.error("  acce "+o(he,2)),console.error("  bg "+o(ve,2)),console.error("  --- "+o(Se,2)),console.error("  Δ "+o(xe,2)),console.error("  delta "+o(Me,2)),he<1&&(me="strongest autoISF factor "+o(A,2)+" weakened to "+o(A*he,2)+" as bg decelerates already",console.error(me),A*=he);let e=1;const i=A;return e=t.low_carb_ez_fcl_profile?(i-1)*t.low_carb_ez_fcl_profile_multiplier+1:t.moderate_carb_ez_fcl_profile?(i-1)*t.moderate_carb_ez_fcl_profile_multiplier+1:t.high_carb_ez_fcl_profile?(i-1)*t.high_carb_ez_fcl_profile_multiplier+1:i,z=Te(e,t.autoISF_min,y,u,r,t,c,a,_),T=o(ae(t)/z,1),ne+=le+de+se+", final Ratio: "+o(z,2)+pe+_e+", final ISF: "+function(e,r){return e.use_autosens_isf_to_calculate_auto_isf_sens?n(e.sens,e)+"→"+n(ae(e),e)+"→"+n(T,e):n(e.sens,e)+"→"+n(T,e)}(t),T}return ne+=", not modified",console.error("autoISF does not modify"),T}(lr,Ye,qe,i,e,l,c,0,Xe,0,Ve,Ze),console.error("----------------------------------"),console.error(" end autoISF"),console.error("----------------------------------"),void 0===a)return we.error="Error: iob_data undefined. ",we;var yr,Ir=a;if(a.length,a.length>1&&(a=Ir[0]),void 0===a.activity||void 0===a.iob)return we.error="Error: iob_data missing some property. ",we;var Tr=((yr=void 0!==a.lastTemp?o((new Date(Ue).getTime()-a.lastTemp.date)/6e4):0)+r.duration)%30;if(console.error("currenttemp:"+r.rate+" lastTempAge:"+yr+"m, tempModulus:"+Tr+"m"),we.temp="absolute",we.deliverAt=Ce,u&&r&&a.lastTemp&&r.rate!==a.lastTemp.rate&&yr>10&&r.duration)return we.reason="Warning: currenttemp rate "+r.rate+" != lastTemp rate "+a.lastTemp.rate+" from pumphistory; canceling temp",d.setTempBasal(0,0,i,we,r);if(r&&a.lastTemp&&r.duration>0){var wr=yr-a.lastTemp.duration;if(wr>5&&yr>10)return we.reason="Warning: currenttemp running but lastTemp from pumphistory ended "+wr+"m ago; canceling temp",d.setTempBasal(0,0,i,we,r)}var Fr=o(-a.activity*lr*5,2),Dr=o(6*(ke-Fr));Dr<0&&(Dr=o(6*(Le-Fr)))<0&&(Dr=o(6*(e.long_avgdelta-Fr)));var Cr=Pe,Or=(Cr=a.iob>0?o(Pe-a.iob*lr):o(Pe-a.iob*Math.min(lr,ae(i))))+Dr;if(void 0===Or||isNaN(Or))return we.error="Error: could not calculate eventualBG. Sensitivity: "+lr+" Deviation: "+Dr,we;var Gr=function(e,r,a){return o(a+(e-r)/24,1)}(qe,Or,Fr);we={temp:"absolute",bg:n(Pe,i),tick:Ae,eventualBG:Or,insulinReq:0,reservoir:m,deliverAt:Ce,sensitivityRatio:Xe,TDD:ee,insulin:Q,avgDelta:n(A,i)};var Ur=[],Ar=[],zr=[],Rr=[];Ur.push(Pe),Ar.push(Pe),Rr.push(Pe),zr.push(Pe);var Pr=i.enableUAM,Er=0,kr=0;Er=o(ke-Fr,1);var Lr=o(ke-Fr,1);csf=lr/i.carb_ratio,console.error("profile.sens:"+n(ae(i),i)+", sens:"+n(lr,i)+", CSF:"+o(csf,1));var jr=o(30*csf*5/60,1);Er>jr&&(console.error("Limiting carb impact from "+Er+" to "+jr+"mg/dL/5m (30g/h)"),Er=jr);var qr=3;Xe&&(qr/=Xe);var Wr=qr;if(l.carbs){qr=Math.max(qr,l.mealCOB/20);var Hr=o((new Date(Ue).getTime()-l.lastCarbTime)/6e4),Nr=(l.carbs-l.mealCOB)/l.carbs;Wr=o(Wr=qr+1.5*Hr/60,1),console.error("Last carbs "+Hr+" minutes ago; remainingCATime:"+Wr+"hours; "+o(100*Nr)+"% carbs absorbed")}var Xr=Math.max(0,Er/5*60*Wr/2)/csf,Yr=90,Vr=1;i.remainingCarbsCap&&(Yr=Math.min(90,i.remainingCarbsCap)),i.remainingCarbsFraction&&(Vr=Math.min(1,i.remainingCarbsFraction));var Zr=1-Vr,$r=Math.max(0,l.mealCOB-Xr-l.carbs*Zr),Jr=($r=Math.min(Yr,$r))*csf*5/60/(Wr/2),Kr=o(l.slopeFromMaxDeviation,2),Qr=o(l.slopeFromMinDeviation,2),ea=Math.min(Kr,-Qr/3),ra=0;0===Er?kr=0:!0===i.floating_carbs?(kr=Math.min(60*Wr/5/2,Math.max(0,l.carbs*csf/Er)),ra=Math.min(60*Wr/5/2,Math.max(0,l.mealCOB*csf/Er)),l.carbs>0&&(ne+=", Floating Carbs:, CID: "+o(kr,1)+", MealCarbs: "+o(l.carbs,1)+", Not Floating:, CID: "+o(ra,1)+", MealCOB: "+o(l.mealCOB,1),console.error("Floating Carbs CID: "+o(kr,1)+" / MealCarbs: "+o(l.carbs,1)+" vs. Not Floating:"+o(ra,1)+" / MealCOB:"+o(l.mealCOB,1)))):kr=Math.min(60*Wr/5/2,Math.max(0,l.mealCOB*csf/Er)),console.error("Carb Impact:"+Er+"mg/dL per 5m; CI Duration:"+o(5*kr/60*2,1)+"hours; remaining CI ("+o(Wr/2,2)+"h peak):",o(Jr,1)+"mg/dL per 5m");var aa,ta,oa,na,ia,sa=999,la=999,da=999,ua=Pe,ma=999,ca=999,_a=999,pa=999,fa=Or,ba=Pe,ga=Pe,ha=0,Ba=[],va=[];try{Ir.forEach((function(e){var r=o(-e.activity*lr*5,2),a=o(-e.iobWithZeroTemp.activity*lr*5,2),t=Er*(1-Math.min(1,Ar.length/12));fa=Ar[Ar.length-1]+r+t;var n=Rr[Rr.length-1]+a,i=Math.max(0,Math.max(0,Er)*(1-Ur.length/Math.max(2*kr,1))),s=Math.min(Ur.length,12*Wr-Ur.length),l=Math.max(0,s/(Wr/2*12)*Jr);i+l,Ba.push(o(l,0)),va.push(o(i,0)),COBpredBG=Ur[Ur.length-1]+r+Math.min(0,t)+i+l;var d=Math.max(0,Lr+zr.length*ea),u=Math.max(0,Lr*(1-zr.length/Math.max(36,1))),m=Math.min(d,u);m>0&&(ha=o(5*(zr.length+1)/60,1)),UAMpredBG=zr[zr.length-1]+r+Math.min(0,t)+m,Ar.length<48&&Ar.push(fa),Ur.length<48&&Ur.push(COBpredBG),zr.length<48&&zr.push(UAMpredBG),Rr.length<48&&Rr.push(n),COBpredBG<ma&&(ma=o(COBpredBG)),UAMpredBG<ca&&(ca=o(UAMpredBG)),fa<_a&&(_a=o(fa)),n<pa&&(pa=o(n));Ar.length>18&&fa<sa&&(sa=o(fa)),fa>ba&&(ba=fa),(kr||Jr>0)&&Ur.length>18&&COBpredBG<la&&(la=o(COBpredBG)),(kr||Jr>0)&&COBpredBG>ba&&(ga=COBpredBG),Pr&&zr.length>12&&UAMpredBG<da&&(da=o(UAMpredBG)),Pr&&UAMpredBG>ba&&UAMpredBG}))}catch(e){console.error("Problem with iobArray.  Optional feature Advanced Meal Assist disabled")}we.predBGs={},Ar.forEach((function(e,r,a){a[r]=o(Math.min(401,Math.max(39,e)))}));for(var Ma=Ar.length-1;Ma>12&&Ar[Ma-1]===Ar[Ma];Ma--)Ar.pop();for(we.predBGs.IOB=Ar,oa=o(Ar[Ar.length-1]),Rr.forEach((function(e,r,a){a[r]=o(Math.min(401,Math.max(39,e)))})),Ma=Rr.length-1;Ma>6&&!(Rr[Ma-1]>=Rr[Ma]||Rr[Ma]<=qe);Ma--)Rr.pop();if(we.predBGs.ZT=Rr,o(Rr[Rr.length-1]),l.mealCOB>0&&(Er>0||Jr>0)){for(Ur.forEach((function(e,r,a){a[r]=o(Math.min(401,Math.max(39,e)))})),Ma=Ur.length-1;Ma>12&&Ur[Ma-1]===Ur[Ma];Ma--)Ur.pop();we.predBGs.COB=Ur,na=o(Ur[Ur.length-1]),Or=Math.max(Or,o(Ur[Ur.length-1]))}if(Er>0||Jr>0){if(Pr){for(zr.forEach((function(e,r,a){a[r]=o(Math.min(401,Math.max(39,e)))})),Ma=zr.length-1;Ma>12&&zr[Ma-1]===zr[Ma];Ma--)zr.pop();we.predBGs.UAM=zr,ia=o(zr[zr.length-1]),zr[zr.length-1]&&(Or=Math.max(Or,o(zr[zr.length-1])))}we.eventualBG=Or}console.error("UAM Impact:"+Lr+"mg/dL per 5m; UAM Duration:"+ha+"hours"),sa=Math.max(39,sa),la=Math.max(39,la),da=Math.max(39,da),aa=o(sa);var xa=l.mealCOB/l.carbs;ta=o(da<999&&la<999?(1-xa)*UAMpredBG+xa*COBpredBG:la<999?(fa+COBpredBG)/2:da<999?(fa+UAMpredBG)/2:fa),pa>ta&&(ta=pa),ua=o(ua=kr||Jr>0?Pr?xa*ma+(1-xa)*ca:ma:Pr?ca:_a);var Sa=da;if(pa<ir)Sa=(da+pa)/2;else if(pa<qe){var ya=(pa-ir)/(qe-ir);Sa=(da+(da*ya+pa*(1-ya)))/2}else pa>da&&(Sa=(da+pa)/2);if(Sa=o(Sa),l.carbs)if(!Pr&&la<999)aa=o(Math.max(sa,la));else if(la<999){var Ia=xa*la+(1-xa)*Sa;aa=o(Math.max(sa,la,Ia))}else aa=Pr?Sa:ua;else Pr&&(aa=o(Math.max(sa,Sa)));aa=Math.min(aa,ta),process.stderr.write("minPredBG: "+n(aa,i)+" minIOBPredBG: "+n(sa,i)+" minZTGuardBG: "+n(pa,i)),la<999&&process.stderr.write(" minCOBPredBG: "+n(la,i)),da<999&&process.stderr.write(" minUAMPredBG: "+n(da,i)),console.error(" avgPredBG:"+n(ta,i)+" COB/Carbs:"+l.mealCOB+"/"+l.carbs),ga>Pe&&(aa=Math.min(aa,ga)),we.COB=l.mealCOB,we.IOB=a.iob,we.BGI=n(Fr,i),we.deviation=n(Dr,i),we.dura_ISFratio=o(Se,2),we.bg_ISFratio=o(ve,2),we.delta_ISFratio=o(Me,2),we.pp_ISFratio=o(xe,2),we.acce_ISFratio=o(he,2),we.auto_ISFratio=o(ae(i)/lr,2),we.ISF=n(lr,i),we.CR=o(i.carb_ratio,2),we.TDD=o(ee,1),we.TDDytd=o(C,1),we.TDD7d=o(O,1),we.target_bg=n(qe,i),we.minDelta=ke,we.expectedDelta=Gr,we.minGuardBG=ua,we.minPredBG=aa;var Ta=function(e,r,a,t){var n=e.smb_delivery_ratio_bg_range;n<10&&(n/=.0555);var i=e.smb_delivery_ratio,s=Math.min(e.smb_delivery_ratio_min,e.smb_delivery_ratio_max),l=Math.max(e.smb_delivery_ratio_min,e.smb_delivery_ratio_max),d=a+n,u=i;return n>0&&(u=s+(l-s)*(r-a)/n,u=Math.max(s,Math.min(l,u))),"fullLoop"==t?(console.error("MB delivery ratio set to "+o(Math.max(i,u),2)+" as max of fixed and interpolated values"),Math.max(i,u)):0==n?(console.error("MB delivery ratio set to fixed value "+o(i,2)),i):r<=a?(console.error("MB delivery ratio limited by minimum value "+o(s,2)),s):r>=d?(console.error("MB delivery ratio limited by maximum value "+o(l,2)),l):(console.error("MB delivery ratio set to interpolated value "+o(u,2)),u)}(i,Pe,qe,xr);we.SMBratio=o(Ta,2);o(Ta,2);let wa="";""!==g&&"Nothing changed"!==g&&(wa="Middleware:, "+g+", ");let Fa="";i.use_autosens_isf_to_calculate_auto_isf_sens&&(Fa="Basal: "+o(i.current_basal,2)+"→"+o(te(i),2)+", Autosens: "+o(s.ratio,2)+" (ISF: "+o(i.sens/s.ratio,0)+"), ");let Da="";i.enable_max_iob_deadbands&&(Da="maxIOB: "+o(oe(i,e,qe),2)+" ("+function(e,r,a){const t=r.glucose;if(e.enable_max_iob_deadbands){const r=e.tight_deadband_range/100*a+a,o=e.loose_deadband_range/100*a+a;if(t>=0&&t<r&&!e.moderate_carb_ez_fcl_profile&&!e.high_carb_ez_fcl_profile)return e.max_iob_tight_deadband;if(t>=r&&t<=o&&!e.moderate_carb_ez_fcl_profile&&!e.high_carb_ez_fcl_profile)return e.max_iob_loose_deadband;if(t>=0&&e.sleep_mode)return e.max_iob_tight_deadband;if(t>=0&&e.automatic_sleep_mode)return e.max_iob_tight_deadband}return e.max_iob}(i,e,qe)+"% of TDD)");let Ca="";i.enable_max_iob_deadbands&&(Ca="tddISF-AF: "+o(i.calculate_isf_from_tdd_numerator_divisor,2)+", "),we.reason=wa+Fa+Da+be+ge+fe+ne+", Standard, BGI: "+we.BGI+", Target: "+we.target_bg+", minPredBG "+n(aa,i)+", minGuardBG "+n(ua,i)+", IOBpredBG "+n(oa,i),na>0&&(we.reason+=", COBpredBG "+n(na,i)),ia>0&&(we.reason+=", UAMpredBG "+n(ia,i)),we.reason+=tddReason,we.reason+="; ";var Oa=Cr;Oa<40&&(Oa=Math.min(ua,Oa));var Ga,Ua=ir-Oa,Aa=240,za=240;if(l.mealCOB>0&&(Er>0||Jr>0)){for(Ma=0;Ma<Ur.length;Ma++)if(Ur[Ma]<We){Aa=5*Ma;break}for(Ma=0;Ma<Ur.length;Ma++)if(Ur[Ma]<ir){za=5*Ma;break}}else{for(Ma=0;Ma<Ar.length;Ma++)if(Ar[Ma]<We){Aa=5*Ma;break}for(Ma=0;Ma<Ar.length;Ma++)if(Ar[Ma]<ir){za=5*Ma;break}}Sr&&ua<ir&&(console.error("minGuardBG "+n(ua,i)+" projected below "+n(ir,i)+" - disabling MB"),De=1,Fe=o((Or-qe)/lr,2),Sr=!1),void 0===i.maxDelta_bg_threshold&&(Ga=.2),void 0!==i.maxDelta_bg_threshold&&(Ga=Math.min(i.maxDelta_bg_threshold,.4)),je>Ga*Pe&&(console.error("maxDelta "+n(je,i)+" > "+100*Ga+"% of BG "+n(Pe,i)+" - disabling MB"),we.reason+="maxDelta "+n(je,i)+" > "+100*Ga+"% of BG "+n(Pe,i)+" - MB disabled!, ",Sr=!1),console.error("BG projected to remain above "+n(We,i)+" for "+Aa+"minutes"),(za<240||Aa<60)&&console.error("BG projected to remain above "+n(ir,i)+" for "+za+"minutes");var Ra=za,Pa=te(i)*lr*Ra/60,Ea=Math.max(0,l.mealCOB-.25*l.carbs),ka=(Ua-Pa)/csf-Ea;if(Pa=o(Pa),ka=o(ka),console.error("naive_eventualBG: "+n(Cr,i)+", bgUndershoot: "+n(Ua,i)+", zeroTempDuration: "+Ra+", zeroTempEffect: "+Pa+", carbsReq: "+ka),"Could not parse clock data"==l.reason?console.error("carbsReq unknown: Could not parse clock data"):ka>=i.carbsReqThreshold&&za<=45&&(we.carbsReq=ka,we.reason+=ka+" add'l carbs req w/in "+za+"m; "),ur&&_r<=cr)return we.reason+="setting AIMI B30 Temp "+t(mr,i)+"U/hr for "+(cr-_r)+"m ",we.temp="absolute",we.deliverAt=Ce,we.duration=Math.min(30,cr-_r),console.error("Forcing AIMI temp "+mr+"U/hr"),d.setTempBasal(mr,30,i,we,r);var La=0;if(Pe<ir&&a.iob<20*-te(i)/60&&ke>0&&ke>Gr)we.reason+="IOB "+a.iob+" < "+o(20*-te(i)/60,2),we.reason+=" and minDelta "+n(ke,i)+" > expectedDelta "+n(Gr,i)+"; ";else if(Pe<ir||ua<ir)return we.reason+="minGuardBG "+n(ua,i)+"<"+n(ir,i),ua<ir&&(De=2),Fe=o((Or-qe)/lr,2),La=o(60*((Ua=qe-ua)/lr)/te(i)),La=30*o(La/30),La=Math.min(120,Math.max(30,La)),d.setTempBasal(0,La,i,we,r);if(i.skip_neutral_temps&&we.deliverAt.getMinutes()>=55){if(!Sr)return we.reason+="; Canceling temp at "+(60-we.deliverAt.getMinutes())+"min before turn of the hour to avoid beeping of MDT. MB disabled anyways.",d.setTempBasal(0,0,i,we,r);console.error(60-we.deliverAt.getMinutes()+"min before turn of the hour, but MB's are enabled - no skipping neutral temps")}var ja=0,qa=Ge;if(Or<We){if(we.reason+="Eventual BG "+n(Or,i)+" < "+n(We,i),ke>Gr&&ke>0&&!ka)return Cr<40?(we.reason+=", naive_eventualBG < 40. ",d.setTempBasal(0,30,i,we,r)):(e.delta>ke?we.reason+=", but Delta "+n(Ae,i)+" > expectedDelta "+n(Gr,i):we.reason+=", but Min. Delta "+ke.toFixed(2)+" > Exp. Delta "+n(Gr,i),r.duration>15&&t(Ge,i)===t(r.rate,i)?(we.reason+=", temp "+r.rate+" ~ req "+o(Ge,2)+"U/hr. ",we):(we.reason+="; setting current basal of "+o(Ge,2)+" as temp. ",d.setTempBasal(Ge,30,i,we,r)));ja=o(ja=2*Math.min(0,(Or-qe)/lr),2);var Wa=Math.min(0,(Cr-qe)/lr);if(Wa=o(Wa,2),ke<0&&ke>Gr)ja=o(ja*(ke/Gr),2);if(qa=t(qa=Ge+2*ja,i),r.duration*(r.rate-Ge)/60<Math.min(ja,Wa)-.3*Ge)return we.reason+=", "+r.duration+"m@"+r.rate.toFixed(2)+" is a lot less than needed. ",d.setTempBasal(qa,30,i,we,r);if(void 0!==r.rate&&r.duration>5&&qa>=.8*r.rate)return we.reason+=", temp "+r.rate+" ~< req "+o(qa,2)+"U/hr. ",we;if(qa<=0){if((La=o(60*((Ua=qe-Cr)/lr)/te(i)))<0?La=0:(La=30*o(La/30),La=Math.min(120,Math.max(0,La))),La>0)return we.reason+=", setting "+La+"m zero temp. ",d.setTempBasal(qa,La,i,we,r)}else we.reason+=", setting "+o(qa,2)+"U/hr. ";return d.setTempBasal(qa,30,i,we,r)}if(ke<Gr&&(we.minDelta=ke,we.expectedDelta=Gr,(Gr-ke>=2||Gr+-1*ke>=2)&&(De=ke>=0&&Gr>0?3:ke<0&&Gr<=0||ke<0&&Gr>=0?4:5),Fe=o((Or-qe)/lr,2),!u||!Sr))return e.delta<ke?we.reason+="Eventual BG "+n(Or,i)+" > "+n(We,i)+" but Delta "+n(Ae,i)+" < Exp. Delta "+n(Gr,i):we.reason+="Eventual BG "+n(Or,i)+" > "+n(We,i)+" but Min. Delta "+ke.toFixed(2)+" < Exp. Delta "+n(Gr,i),r.duration>15&&t(Ge,i)===t(r.rate,i)?(we.reason+=", temp "+r.rate+" ~ req "+Ge+"U/hr. ",we):(we.reason+="; setting current basal of "+Ge+" as temp. ",d.setTempBasal(Ge,30,i,we,r));if(Math.min(Or,aa)<He&&(aa<We&&Or>We&&(De=6,Fe=o((Or-qe)/lr,2)),!u||!Sr))return we.reason+=n(Or,i)+"-"+n(aa,i)+" in range: no temp required",r.duration>15&&t(Ge,i)===t(r.rate,i)?(we.reason+=", temp "+r.rate+" ~ req "+Ge+"U/hr. ",we):(we.reason+="; setting current basal of "+Ge+" as temp. ",d.setTempBasal(Ge,30,i,we,r));if(Or>=He&&(we.reason+="Eventual BG "+n(Or,i)+" >= "+n(He,i)+", "),a.iob>oe(i,e,qe))return we.reason+="IOB "+o(a.iob,2)+" > maxIOB "+o(oe(i,e,qe),2),r.duration>15&&t(Ge,i)===t(r.rate,i)?(we.reason+=", temp "+r.rate+" ~ req "+Ge+"U/hr. ",we):(we.reason+="; setting current basal of "+Ge+" as temp. ",d.setTempBasal(Ge,30,i,we,r));ja=o((Math.min(aa,Or)-qe)/lr,2),Fe=o((Or-qe)/lr,2),ja>oe(i,e,qe)-a.iob?(we.reason+="maxIOB "+o(oe(i,e,qe),2)+", ",console.error("InsReq "+o(ja,2)+" capped at "+o(oe(i,e,qe)-a.iob,2)+" to not exceed maxIOB"),ja=oe(i,e,qe)-a.iob):console.error("MB not limited by maxIOB (insulinReq: "+ja+" U)"),Fe>oe(i,e,qe)-a.iob?console.error("Ev. Bolus limited by maxIOB to "+o(oe(i,e,qe)-a.iob,2)+" (insulinForManualBolus: "+Fe+" U)"):console.error("Ev. Bolus would not be limited by maxIOB (insulinForManualBolus: "+Fe+" U)."),qa=t(qa=Ge+2*ja,i),ja=o(ja,3),we.insulinReq=ja,we.insulinForManualBolus=o(Fe,2),we.manualBolusErrorString=De,we.minDelta=ke,we.expectedDelta=Gr,we.minGuardBG=ua,we.minPredBG=aa,we.threshold=n(ir,i),we.reason="Ins.Req: "+o(ja,2)+", "+we.reason;var Ha=o((new Date(Ue).getTime()-a.lastBolusTime)/6e4,1);if(u&&Sr&&Pe>ir){var Na=o(l.mealCOB/i.carb_ratio,3);if(i.use_autoisf)Xa=i.smb_max_range_extension;else{console.error("ezFCL disabled, MB range extension disabled");var Xa=1}Xa>1&&console.error("MB max range extended from default by factor "+Xa);var Ya=0;void 0===i.maxSMBBasalMinutes?(Ya=o(Xa*te(i)*30/60,1),console.error("profile.maxSMBBasalMinutes undefined: defaulting to 30m")):a.iob>Na&&a.iob>0?(console.error("IOB "+a.iob+" > COB "+l.mealCOB+"; mealInsulinReq = "+Na),i.maxUAMSMBBasalMinutes?(console.error("profile.maxUAMSMBBasalMinutes:",i.maxUAMSMBBasalMinutes,"getBasalValue(profile):",te(i)),Ya=o(Xa*te(i)*i.maxUAMSMBBasalMinutes/60,1)):(console.error("profile.maxUAMSMBBasalMinutes undefined: defaulting to 30m"),Ya=o(30*te(i)/60,1))):(console.error("profile.maxSMBBasalMinutes:",i.maxSMBBasalMinutes,"getBasalValue(profile):",te(i)),Ya=o(Xa*te(i)*i.maxSMBBasalMinutes/60,1));var Va=i.bolus_increment,Za=1/Va;Ta>.5&&console.error("MB Delivery Ratio increased from default 0.5 to "+o(Ta,2));var $a=Math.min(ja*Ta,Ya),Ja="",Ka=ye/100*130/100*oe(i,e,qe)*Qe;$a>Ka-a.iob&&("fullLoop"==xr||"enforced"==xr)&&($a=Ka-a.iob,Ja=", capped by autoISF iobTH",console.error("ezFCL capped MB at "+o($a,2)+" to not exceed 130% of effective iobTH "+o(Ka/130*100,2)+"U")),$a=Math.floor($a*Za)/Za,La=o(60*((qe-(Cr+sa)/2)/lr)/te(i)),ja>0&&$a<Va&&(La=0);var Qa=0;La<=0?La=0:La>=30?(La=30*o(La/30),La=Math.min(60,Math.max(0,La))):(Qa=o(Ge*La/30,2),La=30),we.reason+=" insulinReq "+ja,$a>=Ya&&(we.reason+="; maxBolus "+Ya),La>0&&(we.reason+="; setting "+La+"m low temp of "+Qa+"U/h"),we.reason+=". ";var et=3;i.SMBInterval&&(et=Math.min(10,Math.max(1,i.SMBInterval)));var rt=o(et-Ha,0),at=o(60*(et-Ha),0)%60;if(console.error("naive_eventualBG "+n(Cr,i)+", "+La+"m "+Qa+"U/h temp needed; last bolus "+Ha+"m ago; maxBolus: "+Ya),Ha>et?$a>0&&(we.units=$a,we.reason+="Microbolusing "+$a+"U"+Ja+". "):we.reason+="Waiting "+rt+"m "+at+"s to microbolus again. ",La>0)return we.rate=Qa,we.duration=La,we}var tt=te(i)/i.current_basal*d.getMaxSafeBasal(i);return qa>tt&&(we.reason+="adj. req. rate: "+o(qa,2)+" to maxSafeBasal: "+o(tt,2)+", ",qa=t(tt,i)),r.duration*(r.rate-Ge)/60>=2*ja?(we.reason+=r.duration+"m@"+r.rate.toFixed(2)+" > 2 * insulinReq. Setting temp basal of "+qa+"U/hr. ",d.setTempBasal(qa,30,i,we,r)):void 0===r.duration||0===r.duration?(we.reason+="no temp, setting "+qa+"U/hr. ",d.setTempBasal(qa,30,i,we,r)):r.duration>5&&t(qa,i)<=t(r.rate,i)?(we.reason+="temp "+r.rate+" >~ req "+qa+"U/hr. ",we):(we.reason+="temp "+r.rate+"<"+qa+"U/hr. ",d.setTempBasal(qa,30,i,we,r))}},3531:(e,r,a)=>{var t=a(2296);e.exports=function(e,r){var a=20;void 0!==r&&"string"==typeof r.model&&(t(r.model,"54")||t(r.model,"23"))&&(a=40);return e<1?Math.round(e*a)/a:e<10?Math.round(20*e)/20:Math.round(10*e)/10}},1873:(e,r,a)=>{var t=a(9325).Symbol;e.exports=t},4932:e=>{e.exports=function(e,r){for(var a=-1,t=null==e?0:e.length,o=Array(t);++a<t;)o[a]=r(e[a],a,e);return o}},7133:e=>{e.exports=function(e,r,a){return e==e&&(void 0!==a&&(e=e<=a?e:a),void 0!==r&&(e=e>=r?e:r)),e}},2552:(e,r,a)=>{var t=a(1873),o=a(659),n=a(9350),i=t?t.toStringTag:void 0;e.exports=function(e){return null==e?void 0===e?"[object Undefined]":"[object Null]":i&&i in Object(e)?o(e):n(e)}},7556:(e,r,a)=>{var t=a(1873),o=a(4932),n=a(6449),i=a(4394),s=t?t.prototype:void 0,l=s?s.toString:void 0;e.exports=function e(r){if("string"==typeof r)return r;if(n(r))return o(r,e)+"";if(i(r))return l?l.call(r):"";var a=r+"";return"0"==a&&1/r==-1/0?"-0":a}},4128:(e,r,a)=>{var t=a(1800),o=/^\s+/;e.exports=function(e){return e?e.slice(0,t(e)+1).replace(o,""):e}},4840:(e,r,a)=>{var t="object"==typeof a.g&&a.g&&a.g.Object===Object&&a.g;e.exports=t},659:(e,r,a)=>{var t=a(1873),o=Object.prototype,n=o.hasOwnProperty,i=o.toString,s=t?t.toStringTag:void 0;e.exports=function(e){var r=n.call(e,s),a=e[s];try{e[s]=void 0;var t=!0}catch(e){}var o=i.call(e);return t&&(r?e[s]=a:delete e[s]),o}},9350:e=>{var r=Object.prototype.toString;e.exports=function(e){return r.call(e)}},9325:(e,r,a)=>{var t=a(4840),o="object"==typeof self&&self&&self.Object===Object&&self,n=t||o||Function("return this")();e.exports=n},1800:e=>{var r=/\s/;e.exports=function(e){for(var a=e.length;a--&&r.test(e.charAt(a)););return a}},2296:(e,r,a)=>{var t=a(7133),o=a(7556),n=a(1489),i=a(3222);e.exports=function(e,r,a){e=i(e),r=o(r);var s=e.length,l=a=void 0===a?s:t(n(a),0,s);return(a-=r.length)>=0&&e.slice(a,l)==r}},6449:e=>{var r=Array.isArray;e.exports=r},3805:e=>{e.exports=function(e){var r=typeof e;return null!=e&&("object"==r||"function"==r)}},346:e=>{e.exports=function(e){return null!=e&&"object"==typeof e}},4394:(e,r,a)=>{var t=a(2552),o=a(346);e.exports=function(e){return"symbol"==typeof e||o(e)&&"[object Symbol]"==t(e)}},7400:(e,r,a)=>{var t=a(6993),o=1/0;e.exports=function(e){return e?(e=t(e))===o||e===-1/0?17976931348623157e292*(e<0?-1:1):e==e?e:0:0===e?e:0}},1489:(e,r,a)=>{var t=a(7400);e.exports=function(e){var r=t(e),a=r%1;return r==r?a?r-a:r:0}},6993:(e,r,a)=>{var t=a(4128),o=a(3805),n=a(4394),i=/^[-+]0x[0-9a-f]+$/i,s=/^0b[01]+$/i,l=/^0o[0-7]+$/i,d=parseInt;e.exports=function(e){if("number"==typeof e)return e;if(n(e))return NaN;if(o(e)){var r="function"==typeof e.valueOf?e.valueOf():e;e=o(r)?r+"":r}if("string"!=typeof e)return 0===e?e:+e;e=t(e);var a=s.test(e);return a||l.test(e)?d(e.slice(2),a?2:8):i.test(e)?NaN:+e}},3222:(e,r,a)=>{var t=a(7556);e.exports=function(e){return null==e?"":t(e)}}},r={};function a(t){var o=r[t];if(void 0!==o)return o.exports;var n=r[t]={exports:{}};return e[t](n,n.exports,a),n.exports}a.g=function(){if("object"==typeof globalThis)return globalThis;try{return this||new Function("return this")()}catch(e){if("object"==typeof window)return window}}();var t=a(2982);freeaps_determineBasal=t})();
