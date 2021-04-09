
class KitchenContainer {
  String food_type, store,last_refill,contact;
  double quantity, refill_quantity, threshold, store_price;
  bool auto_order;

  // constructor
  KitchenContainer( this.food_type, this.quantity, this.refill_quantity,
                    this.threshold, this.store,
                    this.store_price, this.last_refill, this.auto_order,this.contact);
}