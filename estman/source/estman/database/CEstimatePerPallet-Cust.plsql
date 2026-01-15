-----------------------------------------------------------------------------
--
--  Logical unit: CEstimatePerPallet
--  Component:    ESTMAN
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


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Reset_To_Defaults(
   estimate_id_ IN NUMBER,
   estimate_revision_no_ IN NUMBER,
   estimate_cost_version_ IN NUMBER,
   node_id_ IN NUMBER)
IS
   info_ VARCHAR2(32000); 
   CURSOR Get_All_Records IS 
      SELECT *
        FROM C_Estimate_Per_Pallet c
       WHERE c.estimate_id = estimate_id 
         AND c.estimate_revision_no = estimate_revision_no_ 
         AND c.estimate_cost_version = estimate_cost_version_ 
         AND c.node_id = node_id_;
BEGIN 
   FOR rec IN Get_All_Records LOOP 
      Remove__(info_, rec.objid, rec.objversion, 'DO');
   END LOOP;
   Add_Defaults(estimate_id_, estimate_revision_no_, estimate_cost_version_, node_id_);
END Reset_To_Defaults;


PROCEDURE Add_Defaults(
   estimate_id_ IN NUMBER,
   estimate_revision_no_ IN NUMBER,
   estimate_cost_version_ IN NUMBER,
   node_id_ IN NUMBER)
IS 
   info_ VARCHAR2(32000);
   attr_ VARCHAR2(32000); 
   objid_ VARCHAR2(32000);
   objversion_ VARCHAR2(32000);
   contract_ company_site_tab.contract%TYPE;
   CURSOR Get_Defaults IS 
      SELECT * 
        FROM c_estimate_per_pal_default_tab c
       WHERE c.contract = contract_;
BEGIN 
   contract_ := Estimate_Node_API.Get_Contract(estimate_id_, estimate_revision_no_, node_id_);
   FOR rec IN get_defaults loop
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ESTIMATE_ID', estimate_id_, attr_);
      Client_SYS.Add_To_Attr('ESTIMATE_REVISION_NO', estimate_revision_no_, attr_);
      Client_SYS.Add_To_Attr('ESTIMATE_COST_VERSION', estimate_cost_version_, attr_);
      Client_SYS.Add_To_Attr('NODE_ID', node_id_, attr_);
      Client_SYS.Add_To_Attr('OVERHEAD_TYPE_DB', rec.overhead_type, attr_);
      Client_SYS.Add_To_Attr('COST_ELEMENT_ID', rec.cost_element_id, attr_);
      Client_SYS.Add_To_Attr('AMOUNT_PER_PALLET', rec.amount_per_pallet, attr_);
      New__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
END Add_Defaults;
-------------------- LU CUST NEW METHODS -------------------------------------
