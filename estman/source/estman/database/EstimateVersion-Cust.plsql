-----------------------------------------------------------------------------
--
--  Logical unit: EstimateVersion
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
@Override 
PROCEDURE Calculate_Level (
   estimate_id_           IN NUMBER,
   estimate_revision_no_  IN NUMBER,
   estimate_cost_version_ IN NUMBER,
   node_id_               IN NUMBER,
   generate_log_          IN VARCHAR2 DEFAULT 'FALSE',
   log_type_              IN VARCHAR2 DEFAULT NULL,
   exec_online_           IN VARCHAR2,
   markup_handling_       IN VARCHAR2)
IS
   contract_ VARCHAR2(5);
   attr_ VARCHAR2(32000);
   $IF Component_Estprd_SYS.INSTALLED $THEN 
   CURSOR C_Get_Estimate_Per_Pallet IS 
      SELECT c.*,
             ec.c_quantity_per_pallet
        FROM c_estimate_per_pallet_tab c
        LEFT OUTER JOIN estimate_component_tab ec
          ON ec.estimate_id = c.estimate_id
         AND ec.estimate_revision_no = c.estimate_revision_no
         AND ec.node_id = c.node_id
       WHERE c.estimate_id = estimate_id_
         AND c.estimate_revision_no = estimate_revision_no_
         AND c.estimate_cost_version = estimate_cost_version_
         AND c.node_id = node_id_;
   $END
BEGIN
   contract_ := Estimate_Node_API.Get_Contract(estimate_id_, estimate_revision_no_, node_id_);
   $IF Component_Estprd_SYS.INSTALLED $THEN 
      FOR rec IN C_Get_Estimate_Per_Pallet LOOP 
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('COST_ELEMENT_ID', rec.cost_element_id, attr_);
         Client_SYS.Add_To_Attr('LEVEL_COST', rec.amount_per_pallet * Estimate_Component_API.Get_Version_Qty(estimate_id_, estimate_revision_no_, node_id_) / rec.c_quantity_per_pallet, attr_);
         Estimate_Node_Cost_API.Add_Level_Cost(estimate_id_, estimate_revision_no_, estimate_cost_version_, node_id_, contract_, attr_);
      END LOOP;
   $END
   super(estimate_id_, estimate_revision_no_, estimate_cost_version_, node_id_, generate_log_, log_type_, exec_online_, markup_handling_);
END Calculate_Level;




-------------------- LU CUST NEW METHODS -------------------------------------
