/*
consider a simple airline flights/booking database
Airports (id, code, name, city)
Planes (id, craft, nseats)
Flights (id, fltNum, plane, source, dest, departs, arrives, price, seatAvail)
Passengers (id, name, address, phone)
bookings (pax, flight, paid)

write triggers to ensure that Flights.SeatsAvail is consistent with
number of bookings on that flight

assume that we never UPDATE a booking (only INDERT.DELETE)
*/

-- check if there is actually seats on the flight
create trigger checkFlight before INSERT on Flights
for each row execute procedure checkFlight();
create or replace function checkFlight() returns trigger
as $$
declare
    numberSeats integer;
begin
    select nseats into numberSeats from planes where id = new.plane;
    if (numberSeats is null) then
        raise exception 'Invalid Plane';
    end if;
    -- else its avaliable, get the total seats
    new.seatAvail := numberSeats;
    return new;
end; $$ language plpgsql;

-- create trigger for insertion/ new booking
-- if its full raise exception
-- otherwise the total avaliable seats -1
create trigger newBooking after INSERT on bookings
for each row execute procedure newBooking();
create or replace function newBooking() returns trigger 
as $$ 
declare
    avaliable  integer;
begin
    select seatAvail into avaliable from Flights where id = new.flight;
    if (avaliable = 0) then
        raise exception 'full flights'
    end if;
    UPDATE  Flights
    SET     SeatsAvail = avaliable - 1
    where   id = new.flight;
    return new;
end; $$ language plpgsql;

-- delete booking
create trigger deleteBooking after DELETE on bookings
for each row execute procedure deleteBooking();
create or replace function deleteBooking() returns trigger
as $$
begin
    UPDATE  Flights 
    SET     seatAvail = seatAvail + 1
    where   id = old.flight;
    return  new;
end; $$ language plpgsql;
