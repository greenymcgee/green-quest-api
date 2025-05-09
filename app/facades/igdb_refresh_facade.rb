class IgdbRefreshFacade < IgdbCreateFacade
  def find_or_initialize_record(id)
    record = model.find_or_initialize_by(igdb_id: id)
    igdb_response = get_igdb_data(id)
    return record if encountered_errors?(id, igdb_response)

    populate_resource_fields(record, igdb_response[:igdb_data])
    record
  end
end
