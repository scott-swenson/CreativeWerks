-----------------------------------------------------------------------------
--
--  Logical unit: CLotBatchRulePart
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
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('RULE_IN_USE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('RULE_IN_USE', Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_FALSE), attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Set_Rule_In_Use(
   part_no_ IN c_lot_batch_rule_part_tab.part_no%TYPE, 
   rule_id_ IN c_lot_batch_rule_part_tab.rule_id%TYPE)
IS
   info_ VARCHAR2(32000);
   attr_ VARCHAR2(32000);
   objid_ VARCHAR2(32000);
   objversion_ VARCHAR2(32000);
   
   CURSOR Get_Active_Parts IS 
      SELECT c.*, 
             c.ROWID AS "rowid"
        FROM c_lot_batch_rule_part_tab c
       WHERE c.rule_in_use = 'TRUE';
  
BEGIN
   FOR rec IN get_active_parts LOOP 
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('RULE_IN_USE_DB', 'FALSE', attr_);
      objversion_ := to_char(rec.rowversion, 'YYYYMMDDHH24MISS');
      C_Lot_Batch_Rule_Part_API.Modify__(info_, rec."rowid", objversion_, attr_, 'DO');      
   END LOOP;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RULE_IN_USE_DB', 'TRUE', attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, rule_id_);
   C_Lot_Batch_Rule_Part_API.Modify__(info_, objid_, objversion_, attr_, 'DO');    
END Set_Rule_In_Use;

-------------------- LU CUST NEW METHODS -------------------------------------
