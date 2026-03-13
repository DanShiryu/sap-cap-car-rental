namespace carrental;

entity Cars {
  key ID      : UUID;
  brand       : String(100);
  model       : String(100);
  plate       : String(20);
  dailyRate   : Decimal(10,2);
  status      : String(20);
}

entity Clients {
  key ID : UUID;
  name   : String(100);
  email  : String(100);
  phone  : String(20);
}

entity Rentals {
  key ID        : UUID;
  car           : Association to Cars;
  client        : Association to Clients;
  startDate     : Date;
  endDate       : Date;
  dailyRate     : Decimal(10,2);
  totalAmount   : Decimal(10,2);
  status        : String(20);
}