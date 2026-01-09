-----------------------------------------------------------------------------
--
--  Logical unit: CLotBatchRuleHistory
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override 
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT c_lot_batch_rule_history_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.history_no := C_Lot_Batch_Rule_Head_Seq.nextval;
   Client_SYS.Set_Item_Value('HISTORY_NO', newrec_.history_no, attr_);
   newrec_.date_entered := sysdate;
   newrec_.user_id := Fnd_Session_API.Get_Fnd_User;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
