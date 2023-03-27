/*===========================================================================================================*/
** Model for Smythe "Child-to-parent Intergenerational Transfers, Social Security and Child Wealth-building" 
/*============================================================================================================*/
cd "D:\ML\W01\168982-V2\DataFiles"

use "./FullData.dta" 


/*============================================================================*/
** Generating graphs used in paper
/*============================================================================*/


rdplot ParentRecTransfers Age62Cutoff if Age62Cutoff >=-10 & Age62Cutoff <=10 & SexofHeadParent ==2, p(2) binselect(qsmv) graph_options(title(Percentage of Female Parents Receiving Money Transfers) ytitle(% of Parents) xtitle(# Years of Parents Age above/below 62))
graph save Graph "./Results\ParentRecTransfers.gph"


rdplot PerChangeWealth Age62Cutoff if Age62Cutoff >=-10 & Age62Cutoff <=10 & RaceChild ==2, p(1) binselect(qsmv) graph_options(title(Wealth of Black Children ) ytitle(Percent Change ) xtitle(# Years of Parents Age above/below 62))
graph save Graph "./Results\WealthofBlackChild.gph"


rdplot PerChangeWealth Age62Cutoff if Age62Cutoff >=-10 & Age62Cutoff <=10 & SexofHeadParent ==2, p(2) binselect(qsmv) graph_options(title(Wealth of Children: Female Parent ) ytitle(Percent Change ) xtitle(# Years of Parents Age above/below 62))
graph save Graph "./Results\WealthofChildFemaleParentP2.gph"


/*===============================================================================================*/
** Main Models by Child/Parent Demographic Groups- Parents/Children Give/Receive Money Transfers
/*================================================================================================*/
rd ParentRecTransfers Age62Cutoff if RaceChild ==1
rd ParentRecTransfers Age62Cutoff if RaceChild ==2
rd ParentRecTransfers Age62Cutoff if SexofHeadChild ==1
rd ParentRecTransfers Age62Cutoff if SexofHeadChild ==2
rd ParentRecTransfers Age62Cutoff if ChildFamIncGrp ==0
rd ParentRecTransfers Age62Cutoff if ChildFamIncGrp ==1
rd ParentRecTransfers Age62Cutoff if ParRaceWhtBlk ==1
rd ParentRecTransfers Age62Cutoff if ParRaceWhtBlk ==2
rd ParentRecTransfers Age62Cutoff if  SexofHeadParent ==1
rd ParentRecTransfers Age62Cutoff if  SexofHeadParent ==2
rd ParentRecTransfers Age62Cutoff if  ParFamIncGrp ==0
rd ParentRecTransfers Age62Cutoff if  ParFamIncGrp ==1


rd ChildGaveTrans Age62Cutoff if RaceChild ==1
rd ChildGaveTrans Age62Cutoff if RaceChild ==2
rd ChildGaveTrans Age62Cutoff if SexofHeadChild ==1
rd ChildGaveTrans Age62Cutoff if SexofHeadChild ==2
rd ChildGaveTrans Age62Cutoff if ChildFamIncGrp ==0
rd ChildGaveTrans Age62Cutoff if ChildFamIncGrp ==1
rd ChildGaveTrans Age62Cutoff if ParRaceWhtBlk ==1
rd ChildGaveTrans Age62Cutoff if ParRaceWhtBlk ==2
rd ChildGaveTrans Age62Cutoff if SexofHeadParent ==1
rd ChildGaveTrans Age62Cutoff if SexofHeadParent ==2
rd ChildGaveTrans Age62Cutoff if ParFamIncGrp ==0
rd ChildGaveTrans Age62Cutoff if ParFamIncGrp ==1

rd ChildRecTransfers Age62Cutoff if RaceChild ==1
rd ChildRecTransfers Age62Cutoff if RaceChild ==2
rd ChildRecTransfers Age62Cutoff if SexofHeadChild ==1
rd ChildRecTransfers Age62Cutoff if SexofHeadChild ==2
rd ChildRecTransfers Age62Cutoff if ChildFamIncGrp ==0
rd ChildRecTransfers Age62Cutoff if ChildFamIncGrp ==1
rd ChildRecTransfers Age62Cutoff if ParRaceWhtBlk ==1
rd ChildRecTransfers Age62Cutoff if ParRaceWhtBlk ==2
rd ChildRecTransfers Age62Cutoff if SexofHeadParent ==1
rd ChildRecTransfers Age62Cutoff if SexofHeadParent ==2
rd ChildRecTransfers Age62Cutoff if ParFamIncGrp ==0
rd ChildRecTransfers Age62Cutoff if ParFamIncGrp==1



/*========================================================================================*/
** Main Models by Race- Net amount of Money Transfers Received by Parents/Children 
/*=========================================================================================*/


rd NetMoneyTransRecPar Age62Cutoff if RaceChild ==1
rd NetMoneyTransRecPar Age62Cutoff if RaceChild ==2
rd NetMoneyTransRecPar Age62Cutoff if SexofHeadChild ==1
rd NetMoneyTransRecPar Age62Cutoff if SexofHeadChild ==2
rd NetMoneyTransRecPar Age62Cutoff if ChildFamIncGrp ==0
rd NetMoneyTransRecPar Age62Cutoff if ChildFamIncGrp ==1
rd NetMoneyTransRecPar Age62Cutoff if ParRaceWhtBlk ==1
rd NetMoneyTransRecPar Age62Cutoff if ParRaceWhtBlk ==2
rd NetMoneyTransRecPar Age62Cutoff if SexofHeadParent ==1
rd NetMoneyTransRecPar Age62Cutoff if SexofHeadParent ==2
rd NetMoneyTransRecPar Age62Cutoff if ParFamIncGrp ==0
rd NetMoneyTransRecPar Age62Cutoff if ParFamIncGrp ==1


rd NetMoneyTransRecChild Age62Cutoff if RaceChild ==1
rd NetMoneyTransRecChild Age62Cutoff if RaceChild ==2
rd NetMoneyTransRecChild Age62Cutoff if SexofHeadChild ==1
rd NetMoneyTransRecChild Age62Cutoff if SexofHeadChild ==2
rd NetMoneyTransRecChild Age62Cutoff if ChildFamIncGrp ==0
rd NetMoneyTransRecChild Age62Cutoff if ChildFamIncGrp ==1
rd NetMoneyTransRecChild Age62Cutoff if ParRaceWhtBlk ==1
rd NetMoneyTransRecChild Age62Cutoff if ParRaceWhtBlk ==2
rd NetMoneyTransRecChild Age62Cutoff if SexofHeadParent ==1
rd NetMoneyTransRecChild Age62Cutoff if SexofHeadParent ==2
rd NetMoneyTransRecChild Age62Cutoff if ParFamIncGrp ==0
rd NetMoneyTransRecChild Age62Cutoff if ParFamIncGrp ==1


/*===================================================================================*/
** Parents/Children Give/Receive Time Transfers by Child Race
/*===================================================================================*/
use "./2013TimeSupplement.dta" 

rd ChildReciveHourTrans Age62Cutoff  if RaceChild ==1
rd ChildReciveHourTrans Age62Cutoff  if RaceChild ==2
rd ChildGiveHourTrans Age62Cutoff  if RaceChild ==1
rd ChildGiveHourTrans Age62Cutoff  if RaceChild ==2
rd ParentReciveHourTrans Age62Cutoff  if RaceChild ==1
rd ParentReciveHourTrans Age62Cutoff  if RaceChild ==2
rd ParentGiveHourTrans Age62Cutoff  if RaceChild ==1
rd ParentGiveHourTrans Age62Cutoff  if RaceChild ==2


/*============================================================================*/
** Descriptives
/*============================================================================*/

bysort RaceChild: su ParentRecTransfers ChildGaveTrans ParentRecTransfersEver ChildGaveTransEver RecSocSecPar RecSocSecParEver SocSec1000 NetMoneyTransRecPar NetMoneyTransRecChild ParentGaveTransfers ChildRecTransfers RealIncParent RealIncChild RealWealthParent RealWealthChild if RaceChild ==1 | RaceChild ==2
bysort RaceChild: su SocSec100 if SocSec100 >0
bysort RaceChild : tab SexofHeadChild if RaceChild ==1 | RaceChild ==2
bysort RaceChild : tab SexofHeadChild if RaceChild ==1 | RaceChild ==2
bysort ParRaceWhtBlk : tab SexofHeadChild


