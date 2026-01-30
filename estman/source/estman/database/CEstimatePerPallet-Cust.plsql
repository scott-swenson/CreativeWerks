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


PROCEDURE Copy(
   from_estimate_id_          IN  NUMBER,
   from_estimate_revision_no_ IN  NUMBER,
   from_estimate_cost_version_no_ IN NUMBER, 
   from_node_id_              IN  NUMBER,
   from_overhead_type_db_     IN  c_estimate_per_pallet_tab.overhead_type%TYPE,
   to_estimate_id_            IN  NUMBER,
   to_estimate_revision_no_   IN  NUMBER,
   to_estimate_cost_version_no_ IN NUMBER,
   to_node_id_         IN  NUMBER)
IS  
   oldrec_ c_estimate_per_pallet_tab%ROWTYPE;
   newrec_ c_estimate_per_pallet_tab%ROWTYPE;
BEGIN
   oldrec_ := Get_Object_By_Keys___(from_estimate_id_, from_estimate_revision_no_, from_estimate_cost_version_no_, from_node_id_, from_overhead_type_db_);
   newrec_ := oldrec_;
   newrec_.estimate_id := to_estimate_id_;
   newrec_.estimate_revision_no := to_estimate_revision_no_;
   newrec_.estimate_cost_version := to_estimate_cost_version_no_;
   newrec_.node_id := to_node_id_;
   New___(newrec_);
END Copy;


PROCEDURE Upsert_Costs(
   from_estimate_id_          IN  NUMBER,
   from_estimate_revision_no_ IN  NUMBER,
   from_node_id_              IN  NUMBER,
   from_estimate_cost_version_no_ IN NUMBER, 
   to_estimate_cost_version_no_ IN NUMBER)
IS
   CURSOR Get_Estimate_Per_Pallet IS 
      SELECT * 
        FROM C_Estimate_Per_Pallet_Tab 
       WHERE Estimate_Id = from_estimate_id_  
         AND Estimate_Revision_No = from_estimate_revision_no_
         AND Estimate_Cost_Version = from_estimate_cost_version_no_
         AND Node_Id = from_node_id_;
   oldrec_ C_Estimate_Per_Pallet_Tab%ROWTYPE;
   newrec_ C_Estimate_Per_Pallet_Tab%ROWTYPE;
   objid_ C_Estimate_Per_Pallet.objid%TYPE;
   objversion_ C_Estimate_Per_Pallet.objversion%TYPE;
   attr_ VARCHAR2(32000);
BEGIN 
   FOR rec IN Get_Estimate_Per_Pallet LOOP 
      --Get the record to copy from
      oldrec_ := Get_Object_By_Keys___(rec.estimate_id, rec.estimate_revision_no, rec.estimate_cost_version, rec.node_id, rec.overhead_type);
      --See if the new record exists
      IF Check_Exist___(oldrec_.estimate_id, oldrec_.estimate_revision_no, to_estimate_cost_version_no_, oldrec_.node_id, oldrec_.overhead_type) THEN 
         newrec_ := oldrec_;
         newrec_.estimate_cost_version := to_estimate_cost_version_no_;
         --make sure the rowkey stays the same.
         newrec_.rowkey := Get_Objkey(newrec_.estimate_id, newrec_.estimate_revision_no, newrec_.estimate_cost_version, newrec_.node_id, C_Est_Overhead_Type_API.Decode(newrec_.overhead_type));
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      ELSE
         newrec_ := oldrec_;
         newrec_.estimate_cost_version := to_estimate_cost_version_no_;
         New___(newrec_);
      END IF;
   END LOOP;
END Upsert_Costs;
-------------------- LU CUST NEW METHODS -------------------------------------
