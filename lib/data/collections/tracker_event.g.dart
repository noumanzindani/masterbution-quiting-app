// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker_event.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrackerEventCollection on Isar {
  IsarCollection<TrackerEvent> get trackerEvents => this.collection();
}

const TrackerEventSchema = CollectionSchema(
  name: r'TrackerEvent',
  id: -735418875316105712,
  properties: {
    r'dateEpochDay': PropertySchema(
      id: 0,
      name: r'dateEpochDay',
      type: IsarType.long,
    ),
    r'emotion': PropertySchema(id: 1, name: r'emotion', type: IsarType.string),
    r'hourOfDay': PropertySchema(
      id: 2,
      name: r'hourOfDay',
      type: IsarType.long,
    ),
    r'intensity': PropertySchema(id: 3, name: r'intensity', type: IsarType.int),
    r'logType': PropertySchema(
      id: 4,
      name: r'logType',
      type: IsarType.byte,
      enumMap: _TrackerEventlogTypeEnumValueMap,
    ),
    r'note': PropertySchema(id: 5, name: r'note', type: IsarType.string),
    r'outcome': PropertySchema(
      id: 6,
      name: r'outcome',
      type: IsarType.byte,
      enumMap: _TrackerEventoutcomeEnumValueMap,
    ),
    r'target': PropertySchema(
      id: 7,
      name: r'target',
      type: IsarType.byte,
      enumMap: _TrackerEventtargetEnumValueMap,
    ),
    r'timestampUtc': PropertySchema(
      id: 8,
      name: r'timestampUtc',
      type: IsarType.dateTime,
    ),
    r'triggers': PropertySchema(
      id: 9,
      name: r'triggers',
      type: IsarType.byteList,
    ),
    r'weekday': PropertySchema(id: 10, name: r'weekday', type: IsarType.long),
  },

  estimateSize: _trackerEventEstimateSize,
  serialize: _trackerEventSerialize,
  deserialize: _trackerEventDeserialize,
  deserializeProp: _trackerEventDeserializeProp,
  idName: r'id',
  indexes: {
    r'timestampUtc': IndexSchema(
      id: -10283478508442510,
      name: r'timestampUtc',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestampUtc',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'logType': IndexSchema(
      id: -1575070705662519133,
      name: r'logType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'logType',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'outcome': IndexSchema(
      id: -2278321333017941260,
      name: r'outcome',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'outcome',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'target': IndexSchema(
      id: -279045078341725161,
      name: r'target',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'target',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'hourOfDay': IndexSchema(
      id: 5889796711003268711,
      name: r'hourOfDay',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'hourOfDay',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'weekday': IndexSchema(
      id: 4342737135278800718,
      name: r'weekday',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'weekday',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'dateEpochDay': IndexSchema(
      id: -2614349907588171094,
      name: r'dateEpochDay',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateEpochDay',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'triggers': IndexSchema(
      id: 8879025416513011443,
      name: r'triggers',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'triggers',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _trackerEventGetId,
  getLinks: _trackerEventGetLinks,
  attach: _trackerEventAttach,
  version: '3.3.2',
);

int _trackerEventEstimateSize(
  TrackerEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.emotion;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.triggers.length;
  return bytesCount;
}

void _trackerEventSerialize(
  TrackerEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dateEpochDay);
  writer.writeString(offsets[1], object.emotion);
  writer.writeLong(offsets[2], object.hourOfDay);
  writer.writeInt(offsets[3], object.intensity);
  writer.writeByte(offsets[4], object.logType.index);
  writer.writeString(offsets[5], object.note);
  writer.writeByte(offsets[6], object.outcome.index);
  writer.writeByte(offsets[7], object.target.index);
  writer.writeDateTime(offsets[8], object.timestampUtc);
  writer.writeByteList(offsets[9], object.triggers);
  writer.writeLong(offsets[10], object.weekday);
}

TrackerEvent _trackerEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrackerEvent();
  object.dateEpochDay = reader.readLong(offsets[0]);
  object.emotion = reader.readStringOrNull(offsets[1]);
  object.hourOfDay = reader.readLong(offsets[2]);
  object.id = id;
  object.intensity = reader.readIntOrNull(offsets[3]);
  object.logType =
      _TrackerEventlogTypeValueEnumMap[reader.readByteOrNull(offsets[4])] ??
      LogType.urge;
  object.note = reader.readStringOrNull(offsets[5]);
  object.outcome =
      _TrackerEventoutcomeValueEnumMap[reader.readByteOrNull(offsets[6])] ??
      Outcome.resisted;
  object.target =
      _TrackerEventtargetValueEnumMap[reader.readByteOrNull(offsets[7])] ??
      BehaviorTarget.porn;
  object.timestampUtc = reader.readDateTime(offsets[8]);
  object.triggers = reader.readByteList(offsets[9]) ?? [];
  object.weekday = reader.readLong(offsets[10]);
  return object;
}

P _trackerEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readIntOrNull(offset)) as P;
    case 4:
      return (_TrackerEventlogTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              LogType.urge)
          as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (_TrackerEventoutcomeValueEnumMap[reader.readByteOrNull(offset)] ??
              Outcome.resisted)
          as P;
    case 7:
      return (_TrackerEventtargetValueEnumMap[reader.readByteOrNull(offset)] ??
              BehaviorTarget.porn)
          as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readByteList(offset) ?? []) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TrackerEventlogTypeEnumValueMap = {
  'urge': 0,
  'lapse': 1,
  'cleanCheckin': 2,
  'orgasm': 3,
  'resistWin': 4,
};
const _TrackerEventlogTypeValueEnumMap = {
  0: LogType.urge,
  1: LogType.lapse,
  2: LogType.cleanCheckin,
  3: LogType.orgasm,
  4: LogType.resistWin,
};
const _TrackerEventoutcomeEnumValueMap = {
  'resisted': 0,
  'surfed': 1,
  'delayed': 2,
  'lapse': 3,
  'neutral': 4,
};
const _TrackerEventoutcomeValueEnumMap = {
  0: Outcome.resisted,
  1: Outcome.surfed,
  2: Outcome.delayed,
  3: Outcome.lapse,
  4: Outcome.neutral,
};
const _TrackerEventtargetEnumValueMap = {
  'porn': 0,
  'masturbation': 1,
  'both': 2,
  'none': 3,
};
const _TrackerEventtargetValueEnumMap = {
  0: BehaviorTarget.porn,
  1: BehaviorTarget.masturbation,
  2: BehaviorTarget.both,
  3: BehaviorTarget.none,
};

Id _trackerEventGetId(TrackerEvent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _trackerEventGetLinks(TrackerEvent object) {
  return [];
}

void _trackerEventAttach(
  IsarCollection<dynamic> col,
  Id id,
  TrackerEvent object,
) {
  object.id = id;
}

extension TrackerEventQueryWhereSort
    on QueryBuilder<TrackerEvent, TrackerEvent, QWhere> {
  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhere> anyTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestampUtc'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhere> anyLogType() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'logType'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhere> anyOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'outcome'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhere> anyTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'target'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhere> anyHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'hourOfDay'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhere> anyWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weekday'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhere> anyDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateEpochDay'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhere> anyTriggersElement() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'triggers'),
      );
    });
  }
}

extension TrackerEventQueryWhere
    on QueryBuilder<TrackerEvent, TrackerEvent, QWhereClause> {
  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  timestampUtcEqualTo(DateTime timestampUtc) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'timestampUtc',
          value: [timestampUtc],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  timestampUtcNotEqualTo(DateTime timestampUtc) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestampUtc',
                lower: [],
                upper: [timestampUtc],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestampUtc',
                lower: [timestampUtc],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestampUtc',
                lower: [timestampUtc],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestampUtc',
                lower: [],
                upper: [timestampUtc],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  timestampUtcGreaterThan(DateTime timestampUtc, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestampUtc',
          lower: [timestampUtc],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  timestampUtcLessThan(DateTime timestampUtc, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestampUtc',
          lower: [],
          upper: [timestampUtc],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  timestampUtcBetween(
    DateTime lowerTimestampUtc,
    DateTime upperTimestampUtc, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestampUtc',
          lower: [lowerTimestampUtc],
          includeLower: includeLower,
          upper: [upperTimestampUtc],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> logTypeEqualTo(
    LogType logType,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'logType', value: [logType]),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> logTypeNotEqualTo(
    LogType logType,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'logType',
                lower: [],
                upper: [logType],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'logType',
                lower: [logType],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'logType',
                lower: [logType],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'logType',
                lower: [],
                upper: [logType],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  logTypeGreaterThan(LogType logType, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'logType',
          lower: [logType],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> logTypeLessThan(
    LogType logType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'logType',
          lower: [],
          upper: [logType],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> logTypeBetween(
    LogType lowerLogType,
    LogType upperLogType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'logType',
          lower: [lowerLogType],
          includeLower: includeLower,
          upper: [upperLogType],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> outcomeEqualTo(
    Outcome outcome,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'outcome', value: [outcome]),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> outcomeNotEqualTo(
    Outcome outcome,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'outcome',
                lower: [],
                upper: [outcome],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'outcome',
                lower: [outcome],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'outcome',
                lower: [outcome],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'outcome',
                lower: [],
                upper: [outcome],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  outcomeGreaterThan(Outcome outcome, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'outcome',
          lower: [outcome],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> outcomeLessThan(
    Outcome outcome, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'outcome',
          lower: [],
          upper: [outcome],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> outcomeBetween(
    Outcome lowerOutcome,
    Outcome upperOutcome, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'outcome',
          lower: [lowerOutcome],
          includeLower: includeLower,
          upper: [upperOutcome],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> targetEqualTo(
    BehaviorTarget target,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'target', value: [target]),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> targetNotEqualTo(
    BehaviorTarget target,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'target',
                lower: [],
                upper: [target],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'target',
                lower: [target],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'target',
                lower: [target],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'target',
                lower: [],
                upper: [target],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> targetGreaterThan(
    BehaviorTarget target, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'target',
          lower: [target],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> targetLessThan(
    BehaviorTarget target, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'target',
          lower: [],
          upper: [target],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> targetBetween(
    BehaviorTarget lowerTarget,
    BehaviorTarget upperTarget, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'target',
          lower: [lowerTarget],
          includeLower: includeLower,
          upper: [upperTarget],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> hourOfDayEqualTo(
    int hourOfDay,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'hourOfDay', value: [hourOfDay]),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  hourOfDayNotEqualTo(int hourOfDay) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'hourOfDay',
                lower: [],
                upper: [hourOfDay],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'hourOfDay',
                lower: [hourOfDay],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'hourOfDay',
                lower: [hourOfDay],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'hourOfDay',
                lower: [],
                upper: [hourOfDay],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  hourOfDayGreaterThan(int hourOfDay, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'hourOfDay',
          lower: [hourOfDay],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> hourOfDayLessThan(
    int hourOfDay, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'hourOfDay',
          lower: [],
          upper: [hourOfDay],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> hourOfDayBetween(
    int lowerHourOfDay,
    int upperHourOfDay, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'hourOfDay',
          lower: [lowerHourOfDay],
          includeLower: includeLower,
          upper: [upperHourOfDay],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> weekdayEqualTo(
    int weekday,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'weekday', value: [weekday]),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> weekdayNotEqualTo(
    int weekday,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'weekday',
                lower: [],
                upper: [weekday],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'weekday',
                lower: [weekday],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'weekday',
                lower: [weekday],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'weekday',
                lower: [],
                upper: [weekday],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  weekdayGreaterThan(int weekday, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'weekday',
          lower: [weekday],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> weekdayLessThan(
    int weekday, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'weekday',
          lower: [],
          upper: [weekday],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause> weekdayBetween(
    int lowerWeekday,
    int upperWeekday, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'weekday',
          lower: [lowerWeekday],
          includeLower: includeLower,
          upper: [upperWeekday],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  dateEpochDayEqualTo(int dateEpochDay) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'dateEpochDay',
          value: [dateEpochDay],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  dateEpochDayNotEqualTo(int dateEpochDay) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateEpochDay',
                lower: [],
                upper: [dateEpochDay],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateEpochDay',
                lower: [dateEpochDay],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateEpochDay',
                lower: [dateEpochDay],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateEpochDay',
                lower: [],
                upper: [dateEpochDay],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  dateEpochDayGreaterThan(int dateEpochDay, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateEpochDay',
          lower: [dateEpochDay],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  dateEpochDayLessThan(int dateEpochDay, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateEpochDay',
          lower: [],
          upper: [dateEpochDay],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  dateEpochDayBetween(
    int lowerDateEpochDay,
    int upperDateEpochDay, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateEpochDay',
          lower: [lowerDateEpochDay],
          includeLower: includeLower,
          upper: [upperDateEpochDay],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  triggersElementEqualTo(int triggersElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'triggers',
          value: [triggersElement],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  triggersElementNotEqualTo(int triggersElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'triggers',
                lower: [],
                upper: [triggersElement],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'triggers',
                lower: [triggersElement],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'triggers',
                lower: [triggersElement],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'triggers',
                lower: [],
                upper: [triggersElement],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  triggersElementGreaterThan(int triggersElement, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'triggers',
          lower: [triggersElement],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  triggersElementLessThan(int triggersElement, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'triggers',
          lower: [],
          upper: [triggersElement],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterWhereClause>
  triggersElementBetween(
    int lowerTriggersElement,
    int upperTriggersElement, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'triggers',
          lower: [lowerTriggersElement],
          includeLower: includeLower,
          upper: [upperTriggersElement],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TrackerEventQueryFilter
    on QueryBuilder<TrackerEvent, TrackerEvent, QFilterCondition> {
  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  dateEpochDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateEpochDay', value: value),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  dateEpochDayGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateEpochDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  dateEpochDayLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateEpochDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  dateEpochDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateEpochDay',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'emotion'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'emotion'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'emotion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'emotion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'emotion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'emotion',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'emotion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'emotion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'emotion',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'emotion',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'emotion', value: ''),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  emotionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'emotion', value: ''),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  hourOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hourOfDay', value: value),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  hourOfDayGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hourOfDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  hourOfDayLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hourOfDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  hourOfDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hourOfDay',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  intensityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'intensity'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  intensityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'intensity'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  intensityEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'intensity', value: value),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  intensityGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'intensity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  intensityLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'intensity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  intensityBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'intensity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  logTypeEqualTo(LogType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'logType', value: value),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  logTypeGreaterThan(LogType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'logType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  logTypeLessThan(LogType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'logType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  logTypeBetween(
    LogType lower,
    LogType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'logType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'note',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  noteStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> noteContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> noteMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'note',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  outcomeEqualTo(Outcome value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'outcome', value: value),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  outcomeGreaterThan(Outcome value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'outcome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  outcomeLessThan(Outcome value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'outcome',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  outcomeBetween(
    Outcome lower,
    Outcome upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'outcome',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> targetEqualTo(
    BehaviorTarget value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'target', value: value),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  targetGreaterThan(BehaviorTarget value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'target',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  targetLessThan(BehaviorTarget value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'target',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition> targetBetween(
    BehaviorTarget lower,
    BehaviorTarget upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'target',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  timestampUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestampUtc', value: value),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  timestampUtcGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timestampUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  timestampUtcLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timestampUtc',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  timestampUtcBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timestampUtc',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  triggersElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'triggers', value: value),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  triggersElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'triggers',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  triggersElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'triggers',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  triggersElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'triggers',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  triggersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'triggers', length, true, length, true);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  triggersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'triggers', 0, true, 0, true);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  triggersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'triggers', 0, false, 999999, true);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  triggersLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'triggers', 0, true, length, include);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  triggersLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'triggers', length, include, 999999, true);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  triggersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  weekdayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'weekday', value: value),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  weekdayGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weekday',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  weekdayLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weekday',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterFilterCondition>
  weekdayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weekday',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TrackerEventQueryObject
    on QueryBuilder<TrackerEvent, TrackerEvent, QFilterCondition> {}

extension TrackerEventQueryLinks
    on QueryBuilder<TrackerEvent, TrackerEvent, QFilterCondition> {}

extension TrackerEventQuerySortBy
    on QueryBuilder<TrackerEvent, TrackerEvent, QSortBy> {
  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy>
  sortByDateEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByEmotion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotion', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByEmotionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotion', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByHourOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensity', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByIntensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensity', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByLogType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logType', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByLogTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logType', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy>
  sortByTimestampUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekday', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> sortByWeekdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekday', Sort.desc);
    });
  }
}

extension TrackerEventQuerySortThenBy
    on QueryBuilder<TrackerEvent, TrackerEvent, QSortThenBy> {
  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy>
  thenByDateEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByEmotion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotion', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByEmotionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotion', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByHourOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensity', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByIntensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intensity', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByLogType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logType', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByLogTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logType', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'target', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy>
  thenByTimestampUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.desc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekday', Sort.asc);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QAfterSortBy> thenByWeekdayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekday', Sort.desc);
    });
  }
}

extension TrackerEventQueryWhereDistinct
    on QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> {
  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateEpochDay');
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByEmotion({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emotion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hourOfDay');
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByIntensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intensity');
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByLogType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logType');
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByNote({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outcome');
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'target');
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestampUtc');
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByTriggers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggers');
    });
  }

  QueryBuilder<TrackerEvent, TrackerEvent, QDistinct> distinctByWeekday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekday');
    });
  }
}

extension TrackerEventQueryProperty
    on QueryBuilder<TrackerEvent, TrackerEvent, QQueryProperty> {
  QueryBuilder<TrackerEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TrackerEvent, int, QQueryOperations> dateEpochDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateEpochDay');
    });
  }

  QueryBuilder<TrackerEvent, String?, QQueryOperations> emotionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emotion');
    });
  }

  QueryBuilder<TrackerEvent, int, QQueryOperations> hourOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hourOfDay');
    });
  }

  QueryBuilder<TrackerEvent, int?, QQueryOperations> intensityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intensity');
    });
  }

  QueryBuilder<TrackerEvent, LogType, QQueryOperations> logTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logType');
    });
  }

  QueryBuilder<TrackerEvent, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<TrackerEvent, Outcome, QQueryOperations> outcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outcome');
    });
  }

  QueryBuilder<TrackerEvent, BehaviorTarget, QQueryOperations>
  targetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'target');
    });
  }

  QueryBuilder<TrackerEvent, DateTime, QQueryOperations>
  timestampUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestampUtc');
    });
  }

  QueryBuilder<TrackerEvent, List<int>, QQueryOperations> triggersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggers');
    });
  }

  QueryBuilder<TrackerEvent, int, QQueryOperations> weekdayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekday');
    });
  }
}
