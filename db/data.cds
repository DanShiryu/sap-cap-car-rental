using { carrental as db } from './schema';

annotate db.Cars with @cds.persistence.skip : false;

annotate db.Clients with @cds.persistence.skip : false;

annotate db.Rentals with @cds.persistence.skip : false;