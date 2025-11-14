CREATE OR REPLACE PROCEDURE dwh.sync_regions()
    LANGUAGE plpgsql
AS
$$
BEGIN
    --------------------------------------------------------------------
    -- 1. Вставка новых записей (ID, которых нет в DWH)
    --------------------------------------------------------------------
    INSERT INTO dwh.regions_hist (region_id, region_name, country, region_code, description)
    SELECT src.region_id,
           src.region_name,
           src.country,
           src.region_code,
           src.description
    FROM dwh_source.regions src
             LEFT JOIN dwh.regions_hist hist
                       ON hist.region_id = src.region_id AND hist.is_active = TRUE
    WHERE hist.region_id IS NULL;
    -- отсутствует активная версия


    --------------------------------------------------------------------
    -- 2. Вставка обновлённых записей (значения изменились)
    --------------------------------------------------------------------
    INSERT INTO dwh.regions_hist (region_id, region_name, country, region_code, description)
    SELECT src.region_id,
           src.region_name,
           src.country,
           src.region_code,
           src.description
    FROM dwh_source.regions src
             JOIN dwh.regions_hist hist
                  ON hist.region_id = src.region_id AND hist.is_active = TRUE
    WHERE (src.region_name, src.country, src.region_code, src.description) IS DISTINCT FROM (hist.region_name,
                                                                                             hist.country,
                                                                                             hist.region_code,
                                                                                             hist.description);

    --------------------------------------------------------------------
    -- 3. Деактивация старых версий при обновлении
    --------------------------------------------------------------------
    UPDATE dwh.regions_hist hist
    SET valid_to  = CURRENT_TIMESTAMP,
        is_active = FALSE
    FROM dwh_source.regions src
    WHERE hist.region_id = src.region_id
      AND hist.is_active = TRUE
      AND (src.region_name, src.country, src.region_code, src.description) IS DISTINCT FROM (hist.region_name,
                                                                                             hist.country,
                                                                                             hist.region_code,
                                                                                             hist.description);

    --------------------------------------------------------------------
    -- 4. Деактивация записей, которые исчезли из источника
    --------------------------------------------------------------------
    UPDATE dwh.regions_hist hist
    SET valid_to  = CURRENT_TIMESTAMP,
        is_active = FALSE
    WHERE hist.is_active = TRUE
      AND NOT EXISTS (SELECT 1
                      FROM dwh_source.regions src
                      WHERE src.region_id = hist.region_id);
END;
$$;
