// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepEntryCollection on Isar {
  IsarCollection<SleepEntry> get sleepEntrys => this.collection();
}

const SleepEntrySchema = CollectionSchema(
  name: r'SleepEntry',
  id: 2946771332265144099,
  properties: {
    r'bedtimeMinutes': PropertySchema(
      id: 0,
      name: r'bedtimeMinutes',
      type: IsarType.long,
    ),
    r'dateEpochDay': PropertySchema(
      id: 1,
      name: r'dateEpochDay',
      type: IsarType.long,
    ),
    r'note': PropertySchema(id: 2, name: r'note', type: IsarType.string),
    r'quality': PropertySchema(id: 3, name: r'quality', type: IsarType.long),
    r'timestampUtc': PropertySchema(
      id: 4,
      name: r'timestampUtc',
      type: IsarType.dateTime,
    ),
    r'wakeMinutes': PropertySchema(
      id: 5,
      name: r'wakeMinutes',
      type: IsarType.long,
    ),
  },

  estimateSize: _sleepEntryEstimateSize,
  serialize: _sleepEntrySerialize,
  deserialize: _sleepEntryDeserialize,
  deserializeProp: _sleepEntryDeserializeProp,
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
  },
  links: {},
  embeddedSchemas: {},

  getId: _sleepEntryGetId,
  getLinks: _sleepEntryGetLinks,
  attach: _sleepEntryAttach,
  version: '3.3.2',
);

int _sleepEntryEstimateSize(
  SleepEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _sleepEntrySerialize(
  SleepEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bedtimeMinutes);
  writer.writeLong(offsets[1], object.dateEpochDay);
  writer.writeString(offsets[2], object.note);
  writer.writeLong(offsets[3], object.quality);
  writer.writeDateTime(offsets[4], object.timestampUtc);
  writer.writeLong(offsets[5], object.wakeMinutes);
}

SleepEntry _sleepEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepEntry();
  object.bedtimeMinutes = reader.readLong(offsets[0]);
  object.dateEpochDay = reader.readLong(offsets[1]);
  object.id = id;
  object.note = reader.readStringOrNull(offsets[2]);
  object.quality = reader.readLong(offsets[3]);
  object.timestampUtc = reader.readDateTime(offsets[4]);
  object.wakeMinutes = reader.readLong(offsets[5]);
  return object;
}

P _sleepEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sleepEntryGetId(SleepEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sleepEntryGetLinks(SleepEntry object) {
  return [];
}

void _sleepEntryAttach(IsarCollection<dynamic> col, Id id, SleepEntry object) {
  object.id = id;
}

extension SleepEntryQueryWhereSort
    on QueryBuilder<SleepEntry, SleepEntry, QWhere> {
  QueryBuilder<SleepEntry, SleepEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhere> anyTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestampUtc'),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhere> anyDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateEpochDay'),
      );
    });
  }
}

extension SleepEntryQueryWhere
    on QueryBuilder<SleepEntry, SleepEntry, QWhereClause> {
  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> idBetween(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> timestampUtcEqualTo(
    DateTime timestampUtc,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'timestampUtc',
          value: [timestampUtc],
        ),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause>
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause>
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> timestampUtcLessThan(
    DateTime timestampUtc, {
    bool include = false,
  }) {
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> timestampUtcBetween(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> dateEpochDayEqualTo(
    int dateEpochDay,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'dateEpochDay',
          value: [dateEpochDay],
        ),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause>
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause>
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> dateEpochDayLessThan(
    int dateEpochDay, {
    bool include = false,
  }) {
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterWhereClause> dateEpochDayBetween(
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
}

extension SleepEntryQueryFilter
    on QueryBuilder<SleepEntry, SleepEntry, QFilterCondition> {
  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  bedtimeMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bedtimeMinutes', value: value),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  bedtimeMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bedtimeMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  bedtimeMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bedtimeMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  bedtimeMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bedtimeMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  dateEpochDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateEpochDay', value: value),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteEqualTo(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteGreaterThan(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteLessThan(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteBetween(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteEndsWith(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteContains(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteMatches(
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> qualityEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'quality', value: value),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  qualityGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'quality',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> qualityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'quality',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition> qualityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'quality',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  timestampUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestampUtc', value: value),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
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

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  wakeMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wakeMinutes', value: value),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  wakeMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'wakeMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  wakeMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'wakeMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterFilterCondition>
  wakeMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'wakeMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SleepEntryQueryObject
    on QueryBuilder<SleepEntry, SleepEntry, QFilterCondition> {}

extension SleepEntryQueryLinks
    on QueryBuilder<SleepEntry, SleepEntry, QFilterCondition> {}

extension SleepEntryQuerySortBy
    on QueryBuilder<SleepEntry, SleepEntry, QSortBy> {
  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByBedtimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy>
  sortByBedtimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByDateEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByTimestampUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByWakeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> sortByWakeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeMinutes', Sort.desc);
    });
  }
}

extension SleepEntryQuerySortThenBy
    on QueryBuilder<SleepEntry, SleepEntry, QSortThenBy> {
  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByBedtimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy>
  thenByBedtimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByDateEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByTimestampUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.desc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByWakeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeMinutes', Sort.asc);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QAfterSortBy> thenByWakeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeMinutes', Sort.desc);
    });
  }
}

extension SleepEntryQueryWhereDistinct
    on QueryBuilder<SleepEntry, SleepEntry, QDistinct> {
  QueryBuilder<SleepEntry, SleepEntry, QDistinct> distinctByBedtimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bedtimeMinutes');
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QDistinct> distinctByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateEpochDay');
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QDistinct> distinctByNote({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QDistinct> distinctByQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quality');
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QDistinct> distinctByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestampUtc');
    });
  }

  QueryBuilder<SleepEntry, SleepEntry, QDistinct> distinctByWakeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wakeMinutes');
    });
  }
}

extension SleepEntryQueryProperty
    on QueryBuilder<SleepEntry, SleepEntry, QQueryProperty> {
  QueryBuilder<SleepEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepEntry, int, QQueryOperations> bedtimeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bedtimeMinutes');
    });
  }

  QueryBuilder<SleepEntry, int, QQueryOperations> dateEpochDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateEpochDay');
    });
  }

  QueryBuilder<SleepEntry, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<SleepEntry, int, QQueryOperations> qualityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quality');
    });
  }

  QueryBuilder<SleepEntry, DateTime, QQueryOperations> timestampUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestampUtc');
    });
  }

  QueryBuilder<SleepEntry, int, QQueryOperations> wakeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wakeMinutes');
    });
  }
}
