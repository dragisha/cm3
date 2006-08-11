/* C version of M3CG_Binary. */
/*   generated: Fri Feb 21 11:53:28 Central Standard Time 1997 */

#define M3CG_Version  0x100

typedef enum {
  M3CG_BEGIN_UNIT,             /* 0 */
  M3CG_END_UNIT,               /* 1 */
  M3CG_IMPORT_UNIT,            /* 2 */
  M3CG_EXPORT_UNIT,            /* 3 */
  M3CG_SET_SOURCE_FILE,        /* 4 */
  M3CG_SET_SOURCE_LINE,        /* 5 */
  M3CG_DECLARE_TYPENAME,       /* 6 */
  M3CG_DECLARE_ARRAY,          /* 7 */
  M3CG_DECLARE_OPEN_ARRAY,     /* 8 */
  M3CG_DECLARE_ENUM,           /* 9 */
  M3CG_DECLARE_ENUM_ELT,       /* 10 */
  M3CG_DECLARE_PACKED,         /* 11 */
  M3CG_DECLARE_RECORD,         /* 12 */
  M3CG_DECLARE_FIELD,          /* 13 */
  M3CG_DECLARE_SET,            /* 14 */
  M3CG_DECLARE_SUBRANGE,       /* 15 */
  M3CG_DECLARE_POINTER,        /* 16 */
  M3CG_DECLARE_INDIRECT,       /* 17 */
  M3CG_DECLARE_PROCTYPE,       /* 18 */
  M3CG_DECLARE_FORMAL,         /* 19 */
  M3CG_DECLARE_RAISES,         /* 20 */
  M3CG_DECLARE_OBJECT,         /* 21 */
  M3CG_DECLARE_METHOD,         /* 22 */
  M3CG_DECLARE_OPAQUE,         /* 23 */
  M3CG_REVEAL_OPAQUE,          /* 24 */
  M3CG_DECLARE_EXCEPTION,      /* 25 */
  M3CG_SET_RUNTIME_PROC,       /* 26 */
  M3CG_SET_RUNTIME_HOOK,       /* 27 */
  M3CG_IMPORT_GLOBAL,          /* 28 */
  M3CG_DECLARE_SEGMENT,        /* 29 */
  M3CG_BIND_SEGMENT,           /* 30 */
  M3CG_DECLARE_GLOBAL,         /* 31 */
  M3CG_DECLARE_CONSTANT,       /* 32 */
  M3CG_DECLARE_LOCAL,          /* 33 */
  M3CG_DECLARE_PARAM,          /* 34 */
  M3CG_DECLARE_TEMP,           /* 35 */
  M3CG_FREE_TEMP,              /* 36 */
  M3CG_BEGIN_INIT,             /* 37 */
  M3CG_END_INIT,               /* 38 */
  M3CG_INIT_INT,               /* 39 */
  M3CG_INIT_PROC,              /* 40 */
  M3CG_INIT_LABEL,             /* 41 */
  M3CG_INIT_VAR,               /* 42 */
  M3CG_INIT_OFFSET,            /* 43 */
  M3CG_INIT_CHARS,             /* 44 */
  M3CG_INIT_FLOAT,             /* 45 */
  M3CG_IMPORT_PROCEDURE,       /* 46 */
  M3CG_DECLARE_PROCEDURE,      /* 47 */
  M3CG_BEGIN_PROCEDURE,        /* 48 */
  M3CG_END_PROCEDURE,          /* 49 */
  M3CG_BEGIN_BLOCK,            /* 50 */
  M3CG_END_BLOCK,              /* 51 */
  M3CG_NOTE_PROCEDURE_ORIGIN,  /* 52 */
  M3CG_SET_LABEL,              /* 53 */
  M3CG_JUMP,                   /* 54 */
  M3CG_IF_TRUE,                /* 55 */
  M3CG_IF_FALSE,               /* 56 */
  M3CG_IF_EQ,                  /* 57 */
  M3CG_IF_NE,                  /* 58 */
  M3CG_IF_GT,                  /* 59 */
  M3CG_IF_GE,                  /* 60 */
  M3CG_IF_LT,                  /* 61 */
  M3CG_IF_LE,                  /* 62 */
  M3CG_CASE_JUMP,              /* 63 */
  M3CG_EXIT_PROC,              /* 64 */
  M3CG_LOAD,                   /* 65 */
  M3CG_LOAD_ADDRESS,           /* 66 */
  M3CG_LOAD_INDIRECT,          /* 67 */
  M3CG_STORE,                  /* 68 */
  M3CG_STORE_INDIRECT,         /* 69 */
  M3CG_LOAD_NIL,               /* 70 */
  M3CG_LOAD_INTEGER,           /* 71 */
  M3CG_LOAD_FLOAT,             /* 72 */
  M3CG_EQ,                     /* 73 */
  M3CG_NE,                     /* 74 */
  M3CG_GT,                     /* 75 */
  M3CG_GE,                     /* 76 */
  M3CG_LT,                     /* 77 */
  M3CG_LE,                     /* 78 */
  M3CG_ADD,                    /* 79 */
  M3CG_SUBTRACT,               /* 80 */
  M3CG_MULTIPLY,               /* 81 */
  M3CG_DIVIDE,                 /* 82 */
  M3CG_NEGATE,                 /* 83 */
  M3CG_ABS,                    /* 84 */
  M3CG_MAX,                    /* 85 */
  M3CG_MIN,                    /* 86 */
  M3CG_ROUND,                  /* 87 */
  M3CG_TRUNC,                  /* 88 */
  M3CG_FLOOR,                  /* 89 */
  M3CG_CEILING,                /* 90 */
  M3CG_CVT_FLOAT,              /* 91 */
  M3CG_DIV,                    /* 92 */
  M3CG_MOD,                    /* 93 */
  M3CG_SET_UNION,              /* 94 */
  M3CG_SET_DIFFERENCE,         /* 95 */
  M3CG_SET_INTERSECTION,       /* 96 */
  M3CG_SET_SYM_DIFFERENCE,     /* 97 */
  M3CG_SET_MEMBER,             /* 98 */
  M3CG_SET_EQ,                 /* 99 */
  M3CG_SET_NE,                 /* 100 */
  M3CG_SET_LT,                 /* 101 */
  M3CG_SET_LE,                 /* 102 */
  M3CG_SET_GT,                 /* 103 */
  M3CG_SET_GE,                 /* 104 */
  M3CG_SET_RANGE,              /* 105 */
  M3CG_SET_SINGLETON,          /* 106 */
  M3CG_NOT,                    /* 107 */
  M3CG_AND,                    /* 108 */
  M3CG_OR,                     /* 109 */
  M3CG_XOR,                    /* 110 */
  M3CG_SHIFT,                  /* 111 */
  M3CG_SHIFT_LEFT,             /* 112 */
  M3CG_SHIFT_RIGHT,            /* 113 */
  M3CG_ROTATE,                 /* 114 */
  M3CG_ROTATE_LEFT,            /* 115 */
  M3CG_ROTATE_RIGHT,           /* 116 */
  M3CG_WIDEN,                  /* 117 */
  M3CG_CHOP,                   /* 118 */
  M3CG_EXTRACT,                /* 119 */
  M3CG_EXTRACT_N,              /* 120 */
  M3CG_EXTRACT_MN,             /* 121 */
  M3CG_INSERT,                 /* 122 */
  M3CG_INSERT_N,               /* 123 */
  M3CG_INSERT_MN,              /* 124 */
  M3CG_SWAP,                   /* 125 */
  M3CG_POP,                    /* 126 */
  M3CG_COPY_N,                 /* 127 */
  M3CG_COPY,                   /* 128 */
  M3CG_ZERO_N,                 /* 129 */
  M3CG_ZERO,                   /* 130 */
  M3CG_LOOPHOLE,               /* 131 */
  M3CG_ABORT,                  /* 132 */
  M3CG_CHECK_NIL,              /* 133 */
  M3CG_CHECK_LO,               /* 134 */
  M3CG_CHECK_HI,               /* 135 */
  M3CG_CHECK_RANGE,            /* 136 */
  M3CG_CHECK_INDEX,            /* 137 */
  M3CG_CHECK_EQ,               /* 138 */
  M3CG_ADD_OFFSET,             /* 139 */
  M3CG_INDEX_ADDRESS,          /* 140 */
  M3CG_START_CALL_DIRECT,      /* 141 */
  M3CG_CALL_DIRECT,            /* 142 */
  M3CG_START_CALL_INDIRECT,    /* 143 */
  M3CG_CALL_INDIRECT,          /* 144 */
  M3CG_POP_PARAM,              /* 145 */
  M3CG_POP_STRUCT,             /* 146 */
  M3CG_POP_STATIC_LINK,        /* 147 */
  M3CG_LOAD_PROCEDURE,         /* 148 */
  M3CG_LOAD_STATIC_LINK,       /* 149 */
  M3CG_COMMENT,                /* 150 */
  LAST_OPCODE } M3CG_opcode;

static const char *M3CG_opnames[] = {
  "begin_unit",             /* 0 */
  "end_unit",               /* 1 */
  "import_unit",            /* 2 */
  "export_unit",            /* 3 */
  "set_source_file",        /* 4 */
  "set_source_line",        /* 5 */
  "declare_typename",       /* 6 */
  "declare_array",          /* 7 */
  "declare_open_array",     /* 8 */
  "declare_enum",           /* 9 */
  "declare_enum_elt",       /* 10 */
  "declare_packed",         /* 11 */
  "declare_record",         /* 12 */
  "declare_field",          /* 13 */
  "declare_set",            /* 14 */
  "declare_subrange",       /* 15 */
  "declare_pointer",        /* 16 */
  "declare_indirect",       /* 17 */
  "declare_proctype",       /* 18 */
  "declare_formal",         /* 19 */
  "declare_raises",         /* 20 */
  "declare_object",         /* 21 */
  "declare_method",         /* 22 */
  "declare_opaque",         /* 23 */
  "reveal_opaque",          /* 24 */
  "declare_exception",      /* 25 */
  "set_runtime_proc",       /* 26 */
  "set_runtime_hook",       /* 27 */
  "import_global",          /* 28 */
  "declare_segment",        /* 29 */
  "bind_segment",           /* 30 */
  "declare_global",         /* 31 */
  "declare_constant",       /* 32 */
  "declare_local",          /* 33 */
  "declare_param",          /* 34 */
  "declare_temp",           /* 35 */
  "free_temp",              /* 36 */
  "begin_init",             /* 37 */
  "end_init",               /* 38 */
  "init_int",               /* 39 */
  "init_proc",              /* 40 */
  "init_label",             /* 41 */
  "init_var",               /* 42 */
  "init_offset",            /* 43 */
  "init_chars",             /* 44 */
  "init_float",             /* 45 */
  "import_procedure",       /* 46 */
  "declare_procedure",      /* 47 */
  "begin_procedure",        /* 48 */
  "end_procedure",          /* 49 */
  "begin_block",            /* 50 */
  "end_block",              /* 51 */
  "note_procedure_origin",  /* 52 */
  "set_label",              /* 53 */
  "jump",                   /* 54 */
  "if_true",                /* 55 */
  "if_false",               /* 56 */
  "if_eq",                  /* 57 */
  "if_ne",                  /* 58 */
  "if_gt",                  /* 59 */
  "if_ge",                  /* 60 */
  "if_lt",                  /* 61 */
  "if_le",                  /* 62 */
  "case_jump",              /* 63 */
  "exit_proc",              /* 64 */
  "load",                   /* 65 */
  "load_address",           /* 66 */
  "load_indirect",          /* 67 */
  "store",                  /* 68 */
  "store_indirect",         /* 69 */
  "load_nil",               /* 70 */
  "load_integer",           /* 71 */
  "load_float",             /* 72 */
  "eq",                     /* 73 */
  "ne",                     /* 74 */
  "gt",                     /* 75 */
  "ge",                     /* 76 */
  "lt",                     /* 77 */
  "le",                     /* 78 */
  "add",                    /* 79 */
  "subtract",               /* 80 */
  "multiply",               /* 81 */
  "divide",                 /* 82 */
  "negate",                 /* 83 */
  "abs",                    /* 84 */
  "max",                    /* 85 */
  "min",                    /* 86 */
  "round",                  /* 87 */
  "trunc",                  /* 88 */
  "floor",                  /* 89 */
  "ceiling",                /* 90 */
  "cvt_float",              /* 91 */
  "div",                    /* 92 */
  "mod",                    /* 93 */
  "set_union",              /* 94 */
  "set_difference",         /* 95 */
  "set_intersection",       /* 96 */
  "set_sym_difference",     /* 97 */
  "set_member",             /* 98 */
  "set_eq",                 /* 99 */
  "set_ne",                 /* 100 */
  "set_lt",                 /* 101 */
  "set_le",                 /* 102 */
  "set_gt",                 /* 103 */
  "set_ge",                 /* 104 */
  "set_range",              /* 105 */
  "set_singleton",          /* 106 */
  "not",                    /* 107 */
  "and",                    /* 108 */
  "or",                     /* 109 */
  "xor",                    /* 110 */
  "shift",                  /* 111 */
  "shift_left",             /* 112 */
  "shift_right",            /* 113 */
  "rotate",                 /* 114 */
  "rotate_left",            /* 115 */
  "rotate_right",           /* 116 */
  "widen",                  /* 117 */
  "chop",                   /* 118 */
  "extract",                /* 119 */
  "extract_n",              /* 120 */
  "extract_mn",             /* 121 */
  "insert",                 /* 122 */
  "insert_n",               /* 123 */
  "insert_mn",              /* 124 */
  "swap",                   /* 125 */
  "pop",                    /* 126 */
  "copy_n",                 /* 127 */
  "copy",                   /* 128 */
  "zero_n",                 /* 129 */
  "zero",                   /* 130 */
  "loophole",               /* 131 */
  "abort",                  /* 132 */
  "check_nil",              /* 133 */
  "check_lo",               /* 134 */
  "check_hi",               /* 135 */
  "check_range",            /* 136 */
  "check_index",            /* 137 */
  "check_eq",               /* 138 */
  "add_offset",             /* 139 */
  "index_address",          /* 140 */
  "start_call_direct",      /* 141 */
  "call_direct",            /* 142 */
  "start_call_indirect",    /* 143 */
  "call_indirect",          /* 144 */
  "pop_param",              /* 145 */
  "pop_struct",             /* 146 */
  "pop_static_link",        /* 147 */
  "load_procedure",         /* 148 */
  "load_static_link",       /* 149 */
  "comment",                /* 150 */
  0 };


#define M3CG_Int1        255
#define M3CG_NInt1       254
#define M3CG_Int2        253
#define M3CG_NInt2       252
#define M3CG_Int4        251
#define M3CG_NInt4       250
#define M3CG_Int8        249
#define M3CG_NInt8       248
#define M3CG_LastRegular 247
