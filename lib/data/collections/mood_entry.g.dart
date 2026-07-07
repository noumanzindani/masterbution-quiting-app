// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMoodEntryCollection on Isar {
  IsarCollection<MoodEntry> get moodEntrys => this.collection();
}

const MoodEntrySchema = CollectionSchema(
  name: r'MoodEntry',
  id: -3945731646672296789,
  properties: {
    r'dateEpochDay': PropertySchema(
      id: 0,
      name: r'dateEpochDay',
      type: IsarType.long,
    ),
    r'mood': PropertySchema(id: 1, name: r'mood', type: IsarType.long),
    r'note': PropertySchema(id: 2, name: r'note', type: IsarType.string),
    r'photoPath': PropertySchema(
      id: 3,
      name: r'photoPath',
      type: IsarType.string,
    ),
    r'tags': PropertySchema(id: 4, name: r'tags', type: IsarType.stringList),
    r'timestampUtc': PropertySchema(
      id: 5,
      name: r'timestampUtc',
      type: IsarType.dateTime,
    ),
    r'voicePath': PropertySchema(
      id: 6,
      name: r'voicePath',
      type: IsarType.string,
    ),
  },

  estimateSize: _moodEntryEstimateSize,
  serialize: _moodEntrySerialize,
  deserialize: _moodEntryDeserialize,
  deserializeProp: _moodEntryDeserializeProp,
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

  getId: _moodEntryGetId,
  getLinks: _moodEntryGetLinks,
  attach: _moodEntryAttach,
  version: '3.3.2',
);

int _moodEntryEstimateSize(
  MoodEntry object,
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
  {
    final value = object.photoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tags.length * 3;
  {
    for (var i = 0; i < object.tags.length; i++) {
      final value = object.tags[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.voicePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _moodEntrySerialize(
  MoodEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dateEpochDay);
  writer.writeLong(offsets[1], object.mood);
  writer.writeString(offsets[2], object.note);
  writer.writeString(offsets[3], object.photoPath);
  writer.writeStringList(offsets[4], object.tags);
  writer.writeDateTime(offsets[5], object.timestampUtc);
  writer.writeString(offsets[6], object.voicePath);
}

MoodEntry _moodEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MoodEntry();
  object.dateEpochDay = reader.readLong(offsets[0]);
  object.id = id;
  object.mood = reader.readLong(offsets[1]);
  object.note = reader.readStringOrNull(offsets[2]);
  object.photoPath = reader.readStringOrNull(offsets[3]);
  object.tags = reader.readStringList(offsets[4]) ?? [];
  object.timestampUtc = reader.readDateTime(offsets[5]);
  object.voicePath = reader.readStringOrNull(offsets[6]);
  return object;
}

P _moodEntryDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _moodEntryGetId(MoodEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _moodEntryGetLinks(MoodEntry object) {
  return [];
}

void _moodEntryAttach(IsarCollection<dynamic> col, Id id, MoodEntry object) {
  object.id = id;
}

extension MoodEntryQueryWhereSort
    on QueryBuilder<MoodEntry, MoodEntry, QWhere> {
  QueryBuilder<MoodEntry, MoodEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhere> anyTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestampUtc'),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhere> anyDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateEpochDay'),
      );
    });
  }
}

extension MoodEntryQueryWhere
    on QueryBuilder<MoodEntry, MoodEntry, QWhereClause> {
  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> idBetween(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> timestampUtcEqualTo(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> timestampUtcNotEqualTo(
    DateTime timestampUtc,
  ) {
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> timestampUtcGreaterThan(
    DateTime timestampUtc, {
    bool include = false,
  }) {
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> timestampUtcLessThan(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> timestampUtcBetween(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> dateEpochDayEqualTo(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> dateEpochDayNotEqualTo(
    int dateEpochDay,
  ) {
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> dateEpochDayGreaterThan(
    int dateEpochDay, {
    bool include = false,
  }) {
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> dateEpochDayLessThan(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterWhereClause> dateEpochDayBetween(
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

extension MoodEntryQueryFilter
    on QueryBuilder<MoodEntry, MoodEntry, QFilterCondition> {
  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> dateEpochDayEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateEpochDay', value: value),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> dateEpochDayBetween(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> moodEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mood', value: value),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> moodGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mood',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> moodLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mood',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> moodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mood',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteEqualTo(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteGreaterThan(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteLessThan(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteBetween(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteStartsWith(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteEndsWith(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteContains(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteMatches(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> photoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'photoPath'),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  photoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'photoPath'),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> photoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'photoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  photoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'photoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> photoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'photoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> photoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'photoPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> photoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'photoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> photoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'photoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> photoPathContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'photoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> photoPathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'photoPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> photoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'photoPath', value: ''),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  photoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'photoPath', value: ''),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tags',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  tagsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsElementContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tags',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tags', value: ''),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tags', value: ''),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', length, true, length, true);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, true, 0, true);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, false, 999999, true);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, true, length, include);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  tagsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', length, include, 999999, true);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> tagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> timestampUtcEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestampUtc', value: value),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> timestampUtcBetween(
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

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> voicePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'voicePath'),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  voicePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'voicePath'),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> voicePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'voicePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  voicePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'voicePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> voicePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'voicePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> voicePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'voicePath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> voicePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'voicePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> voicePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'voicePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> voicePathContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'voicePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> voicePathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'voicePath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition> voicePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'voicePath', value: ''),
      );
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterFilterCondition>
  voicePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'voicePath', value: ''),
      );
    });
  }
}

extension MoodEntryQueryObject
    on QueryBuilder<MoodEntry, MoodEntry, QFilterCondition> {}

extension MoodEntryQueryLinks
    on QueryBuilder<MoodEntry, MoodEntry, QFilterCondition> {}

extension MoodEntryQuerySortBy on QueryBuilder<MoodEntry, MoodEntry, QSortBy> {
  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByDateEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByPhotoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByPhotoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByTimestampUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByVoicePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voicePath', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> sortByVoicePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voicePath', Sort.desc);
    });
  }
}

extension MoodEntryQuerySortThenBy
    on QueryBuilder<MoodEntry, MoodEntry, QSortThenBy> {
  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByDateEpochDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateEpochDay', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByPhotoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByPhotoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoPath', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByTimestampUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestampUtc', Sort.desc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByVoicePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voicePath', Sort.asc);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QAfterSortBy> thenByVoicePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voicePath', Sort.desc);
    });
  }
}

extension MoodEntryQueryWhereDistinct
    on QueryBuilder<MoodEntry, MoodEntry, QDistinct> {
  QueryBuilder<MoodEntry, MoodEntry, QDistinct> distinctByDateEpochDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateEpochDay');
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QDistinct> distinctByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mood');
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QDistinct> distinctByNote({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QDistinct> distinctByPhotoPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QDistinct> distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QDistinct> distinctByTimestampUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestampUtc');
    });
  }

  QueryBuilder<MoodEntry, MoodEntry, QDistinct> distinctByVoicePath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voicePath', caseSensitive: caseSensitive);
    });
  }
}

extension MoodEntryQueryProperty
    on QueryBuilder<MoodEntry, MoodEntry, QQueryProperty> {
  QueryBuilder<MoodEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MoodEntry, int, QQueryOperations> dateEpochDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateEpochDay');
    });
  }

  QueryBuilder<MoodEntry, int, QQueryOperations> moodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mood');
    });
  }

  QueryBuilder<MoodEntry, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<MoodEntry, String?, QQueryOperations> photoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoPath');
    });
  }

  QueryBuilder<MoodEntry, List<String>, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<MoodEntry, DateTime, QQueryOperations> timestampUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestampUtc');
    });
  }

  QueryBuilder<MoodEntry, String?, QQueryOperations> voicePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voicePath');
    });
  }
}
