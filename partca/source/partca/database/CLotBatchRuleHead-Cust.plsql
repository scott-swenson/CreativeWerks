-----------------------------------------------------------------------------
--
--  Logical unit: CLotBatchRuleHead
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
   newrec_     IN OUT c_lot_batch_rule_head_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.rule_id := C_Lot_Batch_Rule_Head_Seq.nextval;
   Client_SYS.Set_Item_Value('RULE_ID', newrec_.rule_id, attr_);
   newrec_.date_created := sysdate;
   newrec_.created_by := Fnd_Session_API.Get_Fnd_User;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override 
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     c_lot_batch_rule_head_tab%ROWTYPE,
   newrec_     IN OUT c_lot_batch_rule_head_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.date_modified := sysdate;
   newrec_.modified_by := Fnd_Session_API.Get_Fnd_User;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
