using { carrental as db } from '../db/schema';

service CarRentalService {
  entity Cars as projection on db.Cars {
    *,
    0 as statusCriticality : Integer
  };

  entity Clients as projection on db.Clients;

  entity Rentals as projection on db.Rentals {
    *,
    car.brand   as carBrand,
    car.model   as carModel,
    client.name as clientName
  } actions {
    action finalizarLocacao();
  };
}