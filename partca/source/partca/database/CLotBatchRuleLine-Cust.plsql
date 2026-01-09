-----------------------------------------------------------------------------
--
--  Logical unit: CLotBatchRuleLine
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
   newrec_     IN OUT c_lot_batch_rule_line_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.line_no := Get_Next_Line_No(newrec_.rule_id);
   Client_SYS.Set_Item_Value('LINE_NO', newrec_.line_no, attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override 
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   rule_id_ c_lot_batch_rule_line_tab.rule_id%TYPE;
   sequence_no_ NUMBER; 
BEGIN
   rule_id_ := Client_SYS.Get_Item_Value('RULE_ID', attr_);
   super(attr_);
   sequence_no_ := Get_Next_Sequence_No(rule_id_);
   Client_SYS.Set_Item_Value('SEQUENCE_NO', sequence_no_, attr_);
   Client_SYS.Set_Item_Value('ADD_SPACE_AFTER_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Set_Item_Value('ADD_SPACE_AFTER', Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_FALSE), attr_);
   Client_SYS.Set_Item_Value('ADD_LINE_AFTER_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Set_Item_Value('ADD_LINE_AFTER', Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_FALSE), attr_);
   Client_SYS.Set_Item_Value('COMPARE_IGNORE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Set_Item_Value('COMPARE_IGNORE', Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_FALSE), attr_);
   Client_SYS.Set_Item_Value('HJ_IGNORE_SQL_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Set_Item_Value('HJ_IGNORE_SQL', Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_FALSE), attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Get_Next_Line_No(
   rule_id_ IN c_lot_batch_rule_line_tab.rule_id%TYPE) RETURN c_lot_batch_rule_line_tab.line_no%TYPE 
IS
   dummy_ c_lot_batch_rule_line_tab.line_no%TYPE;
BEGIN
   SELECT max(line_no)
     INTO dummy_ 
     FROM c_lot_batch_rule_line_tab
    WHERE rule_id = rule_id_;
   dummy_ := nvl(dummy_, 0) + 1;
   RETURN dummy_;
EXCEPTION 
   WHEN no_data_found THEN 
      RETURN 1;
END Get_Next_Line_No;
   

FUNCTION Get_Next_Sequence_No(
   rule_id_ IN c_lot_batch_rule_line_tab.rule_id%TYPE) RETURN c_lot_batch_rule_line_tab.sequence_no%TYPE 
IS
   dummy_ c_lot_batch_rule_line_tab.sequence_no%TYPE;
BEGIN
   SELECT max(sequence_no)
     INTO dummy_ 
     FROM c_lot_batch_rule_line_tab
    WHERE rule_id = rule_id_;
   dummy_ := nvl(dummy_, 0) + 1;
   RETURN dummy_;
EXCEPTION 
   WHEN no_data_found THEN 
      RETURN 1;
END Get_Next_Sequence_No;
-------------------- LU CUST NEW METHODS -------------------------------------
