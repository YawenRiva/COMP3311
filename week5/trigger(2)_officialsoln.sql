create or replace function
	insertFlightTrigger() returns trigger
as $$
declare
	ns integer;
begin
	select nseats into ns from Planes where id = new.plane;
	if (ns is null) then
		raise exception 'Invalid plane';
	end if;
	-- all seats on that plane are available 
	new.seatsAvail := ns;
	return new;
end;
$$ language plpgsql;

create trigger insertFlightTrigger
before insert on Flights
for each row execute procedure insertFlightTrigger();

create or replace function
	insertBookingTrigger() returns trigger
as $$
declare
	avail integer;
begin
	select seatsAvail into avail from Flights where id=new.flight;
	if (avail = 0) then
		raise exception 'Flight is full';
	end if;
	update Flights set seatsAvail = avail - 1
	where id = new.flight;
	return new;
end;
$$ language plpgsql;

create trigger insertBookingTrigger
after insert on Bookings
for each row execute procedure insertBookingTrigger();

create or replace function
	deleteBookingTrigger() returns trigger
as $$
begin
	update Flights set seatsAvail = seatsAvail + 1
	where id = old.flight;
	return new;
end;
$$ language plpgsql;

create trigger deleteBookingTrigger
after delete on Bookings
for each row execute procedure deleteBookingTrigger();
