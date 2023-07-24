-- if user_id is null, find all reservations with in during for the resource.
-- if resource_id is null, find all reservations with in during for the user.
-- if both are null, find all reservations with in during.
-- if both set, find all reservations with in during for the resource and user.
CREATE OR REPLACE FUNCTION rsvp.query(uid TEXT, rid TEXT, during TSTZRANGE) RETURNS TABLE (LIKE rsvp.reservations) AS $$
BEGIN
    IF uid IS NULL AND rid IS NULL THEN
        RETURN QUERY SELECT * FROM rsvp.reservations WHERE during @> timespan;
    ELSIF uid IS NULL THEN
        RETURN QUERY SELECT * FROM rsvp.reservations WHERE resource_id = rid AND during @> timespan;
    ELSIF rid IS NULL THEN
        RETURN QUERY SELECT * FROM rsvp.reservations WHERE user_id = uid AND during @> timespan;
    ELSE
        RETURN QUERY SELECT * FROM rsvp.reservations WHERE user_id = uid AND resource_id = rid AND during @> timespan;
    END IF;
END
$$ LANGUAGE plpgsql;
