def replace_zipcode_with_postalcode(data_type: list[dict[str, typing.Any]]):
    """ Replaces every field/column that has the name `zipcode` with the name `postalcode` in the given input. """
    new_rows = []
    for row in data_type:  # n
        new_row: dict[str, typing.Any] = {}
        for col, val in row.items(): # n * n
            col = 'postalcode' if col == 'zipcode' else col
            new_row[col] = val
        new_rows.append(new_row)
    data_type.clear()
    data_type.extend(new_rows)


    ;;

    new_rows = []
    for row in data_types:
        if row.key('postalCode') is not None:
            new_rows.append({'zipcode': row.value()})
            

# data_type
# row
