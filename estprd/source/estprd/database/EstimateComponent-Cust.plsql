-----------------------------------------------------------------------------
--
--  Logical unit: EstimateComponent
--  Component:    ESTPRD
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
   Client_SYS.Set_Item_Value('C_QUANTITY_PER_PALLET', 1, attr_);
   Client_SYS.Set_Item_Value('C_CONSUMER_UNIT_PER_UOM', 1, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     estimate_component_tab%ROWTYPE,
   newrec_ IN OUT estimate_component_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.c_quantity_per_pallet IS NOT NULL)
      AND (indrec_.c_quantity_per_pallet)
      AND (Validate_SYS.Is_Changed(oldrec_.c_quantity_per_pallet, newrec_.c_quantity_per_pallet)) THEN
      IF newrec_.c_quantity_per_pallet < 0 THEN 
         Negatives_Not_Allowed___('Quantity Per Pallet');
      ELSIF newrec_.c_quantity_per_pallet = 0 THEN 
         Zero_Not_Allowed___('Quantity Per Pallet');
      END IF;
   END IF;
   IF (newrec_.c_consumer_unit_per_uom IS NOT NULL)
      AND (indrec_.c_consumer_unit_per_uom)
      AND (Validate_SYS.Is_Changed(oldrec_.c_consumer_unit_per_uom, newrec_.c_consumer_unit_per_uom)) THEN
      IF newrec_.c_consumer_unit_per_uom < 0 THEN 
         Negatives_Not_Allowed___('Consumer Unit Per UoM');
      ELSIF newrec_.c_consumer_unit_per_uom = 0 THEN 
         Zero_Not_Allowed___('Consumer Unit Per UoM');
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


PROCEDURE Negatives_Not_Allowed___(
   column_name_ IN VARCHAR2)
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'NEGATIVENOTALLOWED: Negative values not allowed for :P1.', column_name_);
END Negatives_Not_Allowed___;


PROCEDURE Zero_Not_Allowed___(
   column_name_ IN VARCHAR2)
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'ZERONOTALLOWED: Zero not allowed for :P1.', column_name_);
END Zero_Not_Allowed___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION C_Get_Total_Pallets(
   estimate_id_          IN  NUMBER,
   estimate_revision_no_ IN  NUMBER,
   node_id_              IN  NUMBER) RETURN NUMBER 
IS 
   rec_   estimate_component_tab%ROWTYPE;
   quantity_per_pallet_ NUMBER;
   component_qty_required_ NUMBER;
BEGIN
   rec_ := Get_Object_By_Keys___(estimate_id_, estimate_revision_no_, node_id_);
   component_qty_required_ := Get_Comp_Qty_Required(estimate_id_, estimate_revision_no_, node_id_);
   IF rec_.c_quantity_per_pallet IS NULL THEN 
      quantity_per_pallet_ := 1;
   ELSIF rec_.c_quantity_per_pallet = 0 THEN 
      quantity_per_pallet_ := 1;
   ELSE
      quantity_per_pallet_ := rec_.c_quantity_per_pallet;
   END IF;
   RETURN CEIL(component_qty_required_ / quantity_per_pallet_);
END C_Get_Total_Pallets;


FUNCTION C_Get_Total_Consumer_Units(
   estimate_id_          IN  NUMBER,
   estimate_revision_no_ IN  NUMBER,
   node_id_              IN  NUMBER) RETURN NUMBER 
IS 
   rec_   estimate_component_tab%ROWTYPE;
   consumer_units_ NUMBER;
   component_qty_required_ NUMBER;
BEGIN
   rec_ := Get_Object_By_Keys___(estimate_id_, estimate_revision_no_, node_id_);
   component_qty_required_ := Get_Comp_Qty_Required(estimate_id_, estimate_revision_no_, node_id_);
   IF rec_.c_consumer_unit_per_uom IS NULL THEN 
      consumer_units_ := 0;
   ELSE 
      consumer_units_ := rec_.c_consumer_unit_per_uom;
   END IF;
   RETURN component_qty_required_ * consumer_units_;
END C_Get_Total_Consumer_Units;


-------------------- LU CUST NEW METHODS -------------------------------------
