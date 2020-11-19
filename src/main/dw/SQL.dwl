%dw 2.0

fun SELECT(keys) =
    keys match {
        case is String -> "SELECT $(keys)"
        case is Array<StringCoerceable> -> "SELECT $((keys default []) joinBy ', ')"
    }

fun FROM(query: String, tableName: String) =
    "$(query) FROM $(tableName default '')"

fun WHERE(query: String, where: String) =
    if (isEmpty(where)) query
    else "$(query) WHERE $(where)"

fun OR(left: String, right: String) =
    WHERE_ANDOR(left, right, "OR")

fun AND(left: String, right: String) =
    WHERE_ANDOR(left, right, "AND")

fun WHERE_ANDOR(left: String, right: String, joiner: String) =
    if (isEmpty(left)) right
    else if (isEmpty(right)) left
    else if ((right contains " AND ") or (right contains " OR ")) "$(left) $(joiner) ($(right))"
    else "$(left) $(joiner) $(right)"

fun IN(keyName: String, values: Array, wrapIn: String = "", separateWith: String = ", ") =
    if (sizeOf(values default []) == 0) ""
    else "$(keyName) IN (" ++ ((values default []) map "$(wrapIn):$(keyName)_$($$)$(wrapIn)" joinBy separateWith) ++ ")"

fun PARAMS_IN(keyName: String, values: Array, wrapIn: String = "") =
    if (sizeOf(values default []) == 0) {}
    else (values reduce (val, res={}) ->
        res - "index" ++ {
            "$(keyName)_$(res.index default 0)": val
        } ++ {
            index: (res.index default 0) + 1
        }) - "index"

fun LIMIT(query: String, limit: Number) =
    if (limit == null) ""
    else "$(query) LIMIT $(limit)"

fun OFFSET(query: String, offset: Number) =
    if (offset == null) ""
    else "$(query) OFFSET $(offset)"