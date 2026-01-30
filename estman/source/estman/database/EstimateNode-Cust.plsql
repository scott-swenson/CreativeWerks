-----------------------------------------------------------------------------
--
--  Logical unit: EstimateNode
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
@Overtake Core
PROCEDURE Copy (
   to_node_id_                OUT NUMBER,
   from_estimate_id_          IN  NUMBER,
   from_estimate_revision_no_ IN  NUMBER,
   from_node_id_              IN  NUMBER,
   to_estimate_id_            IN  NUMBER,
   to_estimate_revision_no_   IN  NUMBER,
   to_parent_node_id_         IN  NUMBER)
IS
   $ADD
   CURSOR get_estimate_per_pallet(from_estimate_id_sub_ IN NUMBER, 
                                  from_estimate_revision_no_sub_ IN NUMBER, 
                                  from_estimate_cost_version_sub_ IN NUMBER,
                                  from_node_sub_ IN NUMBER) IS
      SELECT *
        FROM C_Estimate_Per_Pallet_Tab
       WHERE estimate_id = from_estimate_id_sub_
         AND estimate_revision_no = from_estimate_revision_no_sub_
         AND estimate_cost_version = from_estimate_cost_version_sub_
         AND node_id = from_node_sub_
         ORDER BY overhead_type ASC;
   $END
BEGIN
   $SEARCH
   Estimate_Markup_API.Copy_Markup(from_estimate_id_, from_estimate_revision_no_, vers_rec_.estimate_cost_version, from_node_id_, to_estimate_id_, to_estimate_revision_no_, vers_rec_.estimate_cost_version, to_node_id_);
   $APPEND
   FOR pallet_rec IN get_estimate_per_pallet(from_estimate_id_, from_estimate_revision_no_, vers_rec_.estimate_cost_version, from_node_id_) LOOP 
      C_Estimate_Per_Pallet_API.Copy(from_estimate_id_, from_estimate_revision_no_, vers_rec_.estimate_cost_version, from_node_id_, pallet_rec.overhead_type, to_estimate_id_, to_estimate_revision_no_, vers_rec_.estimate_cost_version, to_node_id_);
   END LOOP;
   $END
END Copy;




-------------------- LU CUST NEW METHODS -------------------------------------
