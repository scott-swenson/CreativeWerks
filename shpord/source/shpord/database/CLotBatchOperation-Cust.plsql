-----------------------------------------------------------------------------
--
--  Logical unit: CLotBatchOperation
--  Component:    SHPORD
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Lot_Batch_Default IS RECORD(
   order_no shop_order_operation_tab.order_no%TYPE,
   release_no shop_order_operation_tab.release_no%TYPE,
   sequence_no shop_order_operation_tab.sequence_no%TYPE,
   operation_no shop_order_operation_tab.operation_no%TYPE,
   contract site_tab.contract%TYPE,
   part_no part_catalog_tab.part_no%TYPE,
   shift_id c_lot_batch_shift_tab.shift_id%TYPE,
   manufacture_date c_lot_batch_calendar_tab.date_full%TYPE,
   customer_id part_catalog_tab.c_customer_id%TYPE,
   customer_name customer_info_tab.name%TYPE,
   job_lot_batch_no lot_batch_master_tab.lot_batch_no%TYPE,
   job_lot_batch_override  lot_batch_master_tab.lot_batch_no%TYPE,
   finished_good_lot_batch_no lot_batch_master_tab.lot_batch_no%TYPE,
   finish_good_lot_batch_override  lot_batch_master_tab.lot_batch_no%TYPE,
   proposed_location shop_ord_tab.proposed_location%TYPE,
   pallet_quantity INTEGER,
   season VARCHAR2(100),
   oldest_rm_item part_catalog_tab.part_no%TYPE,
   oldest_rm_lot lot_batch_master_tab.lot_batch_no%TYPE,
   work_center work_center_tab.work_center_no%TYPE,
   work_center_alias c_work_center_alias_tab.alias%type
);

TYPE Lot_Batch_Defaults IS TABLE OF Lot_Batch_Default;
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Get_Lot_Batch_Parameters(
   order_no_ IN shop_order_operation_tab.order_no%TYPE,
   release_no_ IN shop_order_operation_tab.release_no%TYPE,
   sequence_no_ IN shop_order_operation_tab.sequence_no%TYPE,
   operation_no_ IN shop_order_operation_tab.operation_no%TYPE,
   manufacture_date_ IN c_lot_batch_calendar_tab.date_full%TYPE DEFAULT NULL) RETURN Lot_Batch_Defaults PIPELINED 
IS
   output_ Lot_Batch_Default; 
   operation_rec_ Shop_Order_Operation_API.Public_Rec;
   order_rec_ Shop_Ord_API.Public_Rec;
   part_rec_ Part_Catalog_API.Public_Rec;
   alias_rec_ C_Work_Center_Alias_API.Public_Rec;
BEGIN
   operation_rec_ := Shop_Order_Operation_API.Get(order_no_, release_no_, sequence_no_, operation_no_);
   order_rec_ := Shop_Ord_API.Get(order_no_, release_no_, sequence_no_);
   part_rec_ := Part_Catalog_API.Get(order_rec_.part_no);
   alias_rec_ := C_Work_Center_Alias_API.Get(operation_rec_.contract, operation_rec_.work_center_no, part_rec_.c_customer_id);
   output_.order_no := order_no_;
   output_.release_no := release_no_;
   output_.sequence_no := sequence_no_;
   output_.operation_no := operation_no_;
   output_.contract := operation_rec_.contract;
   output_.part_no := part_rec_.part_no;
   output_.manufacture_date := nvl(trunc(manufacture_date_), trunc(sysdate));
   output_.customer_id := part_rec_.c_customer_id;
   output_.customer_name := Customer_Info_API.Get_Name(part_rec_.c_customer_id);
   output_.proposed_location := order_rec_.proposed_location;
   output_.work_center := operation_rec_.work_center_no;
   output_.work_center_alias := alias_rec_.alias;  
   --need more values to finish out the set, including the API we will use to generate the lot batch no.
  PIPE ROW (output_);   
END Get_Lot_Batch_Parameters;

-------------------- LU CUST NEW METHODS -------------------------------------
