/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>
#include <stdint.h>
#include <string>
#include <iostream>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */

static int commentLayer =0;
static std::string str="";

static int errorflag = 0;

%}

/*
 * Define names for regular expressions here.
 */
LE              <=
DARROW          =>
ASSIGN          <-

SPACE           [ \t\f\r\v]

INT             [0-9]+
NAMECHAR        [0-9a-zA-Z_]
TYPE            [A-Z]{NAMECHAR}*
OBJECT          [a-z]{NAMECHAR}*
TRUE            t[Rr][Uu][Ee]
FALSE           f[Aa][Ll][Ss][Ee]

%x COMMENT
%x STR
%x ERRORSTR

%option noyywrap
%%
 /*
  *  Nested comments
  */

"(*" {
  BEGIN(COMMENT);
  commentLayer = 1;
 }

<COMMENT>"\n" {
  curr_lineno ++;
}

<COMMENT><<EOF>> {
  cool_yylval.error_msg = "EOF in comment";
  BEGIN(0);
  return ERROR;
}

<COMMENT>. {

}

<COMMENT>"(*" {
  commentLayer ++;
}

<COMMENT>"*)" {
  commentLayer --;
  if (commentLayer == 0 ) BEGIN(0);
}

\*\) {
    cool_yylval.error_msg = "Unmatched *)";
    return (ERROR);
}

--.* {}


 /*
  *  The multiple-character operators.
  */
{DARROW}		{ return (DARROW); }
{ASSIGN}    { return (ASSIGN); }
{LE}        { return (LE); }

 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */
[\[\]\'>] {
    cool_yylval.error_msg = yytext;
    return (ERROR);
}
(?i:CLASS)		{ return (CLASS); }
(?i:ELSE)		  { return (ELSE); }
(?i:FI)			  { return (FI); }
(?i:IF)			  { return (IF); }
(?i:IN)			  { return (IN); }
(?i:INHERITS)	{ return (INHERITS); }
(?i:LET)		  { return (LET); }
(?i:LOOP)		  { return (LOOP); }
(?i:POOL)		  { return (POOL); }
(?i:THEN)		  { return (THEN); }
(?i:WHILE)		{ return (WHILE); }
(?i:CASE)		  { return (CASE); }
(?i:ESAC)		  { return (ESAC); }
(?i:OF)			  { return (OF); }
(?i:NEW)		  { return (NEW); }
(?i:LE)			  { return (LE); }
(?i:NOT)		  { return (NOT); }
(?i:ISVOID)		{ return (ISVOID); }

{TRUE} {
  cool_yylval.boolean = true;
  return (BOOL_CONST);
}
{FALSE} {
  cool_yylval.boolean = false;
  return (BOOL_CONST);
}
{INT} {
  cool_yylval.symbol = inttable.add_string(yytext);
  return (INT_CONST);
}

{TYPE} {
  cool_yylval.symbol = idtable.add_string(yytext);
  return (TYPEID);
}

{OBJECT} {
  cool_yylval.symbol = idtable.add_string(yytext);
  return (OBJECTID);
}

{SPACE} {}

[\n] {
  curr_lineno ++;
}

 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */

\" {
  BEGIN (STR);
  str = "";
}

<STR><<EOF>> {
  cool_yylval.error_msg = "EOF in string constant";
  BEGIN(0);
  return ERROR;
}

<STR>\\. {
  // std :: cout<<"SPACE: "<<yytext<<endl;
  switch (yytext[1]){
    case 'n': str.append("\n"); break;
    case 'b': str.append("\b"); break;
    case 'f': str.append("\f"); break;
    case 't': str.append("\t"); break;
    default : str.push_back(yytext[1]);
  }
}

<STR>\" {
  if (str.length()>= MAX_STR_CONST ) {
    cool_yylval.error_msg="String constant too long"; 
    BEGIN(0); return ERROR;}
  BEGIN(0);
  cool_yylval.symbol = stringtable.add_string((char*)str.c_str());
  return (STR_CONST);
}

<STR>\\\n {
  str.push_back(yytext[1]);
  curr_lineno ++;
}

<STR>. {
  if (yytext[0]==0) {cool_yylval.error_msg = "String contains null character."; BEGIN(ERRORSTR);}
  str.push_back(yytext[0]);
}

<STR>[\n] {
  cool_yylval.error_msg = "Unterminated string constant";
  curr_lineno ++;
  BEGIN(0);
  return ERROR;
}

<ERRORSTR>[\"\n] {
  BEGIN(0);
  return ERROR;
}

<ERRORSTR>. {

}

[\(\)\{\}<=,:;~@] {
    return yytext[0];
}

[\-\+\*\/\.] {
    return yytext[0];
}

. {
  if (yytext[0]==0) {cool_yylval.error_msg = "\000"; return ERROR;}
  cool_yylval.error_msg = yytext; 
  return ERROR;
}

%%