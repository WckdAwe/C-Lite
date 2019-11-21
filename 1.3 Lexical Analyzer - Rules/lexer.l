%{
#include "lexer.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <string.h>

int lineno = 1;             /* Μπορείτε εναλλακτικά να βασιστείτε στην ενσωματωμένη μεταβλητή του Flex 'yylineno' προσθέτοντας παρακάτω την επιλογή '%option yylineno' 
                               Εμείς θα χρησιμοποιήσουμε το yylineno στην επόμενη διάλεξη, άρα θα σβήσουμε το lineno */

%}

%option case-insensitive
%option yylineno
%option noyywrap


LETTER      [a-zA-Z]
DIGIT       [0-9]
CHARACTER   {LETTER}|{DIGIT}
NZNUMBER    [1-9]{DIGIT}*|0

ID          _?{LETTER}({LETTER}|{DIGIT}|_)*
ICONST      {NZNUMBER}
FCONST      {NZNUMBER}\.{DIGIT}*
CCONST      \'.\'
WHITESPACE  [ \t]

/*
    ΠΡΙΝ ΠΡΟΧΩΡΗΣΟΥΜΕ:

    Η μεταβλητή 'yytext' είναι ενσωματωμένη μεταβλητή τύπου char* του Flex στην οποία αποθηκεύεται κάθε φορά η τελευταία λέξη που διάβασε-εντόπισε.
    Ακόμη και αν εντοπιστεί ο ακέραιος αριθμός 101, θα αποθηκευτεί σε αυτή ως string και όχι ως ακέραιος. Αργότερα θα χρησιμοποιήσουμε τη συνάρτηση
    'atoi' για μετατροπή ενός string σε ακέραιο αριθμό. Παρακάτω χρησιμοποιήσουμε κάποιες φορές την μεταβλητή 'yytext' ως παράμετρο στη printf.

    Τον τελεστή SIZEOP ('sizeof') τον προσθέσαμε ΠΑΝΩ από την κανονική έκφραση των αναγνωριστικών (ID), ξεχωριστά από τους υπόλοιπους τελεστές,
    για να μην τον αναγνωρίζει ως αναγνωριστικό.

    Το σύμβολο EOF (End Of File) είναι η μοναδική εξαίρεση της δεύτερης ενότητας για το οποίο δε γράφουμε κάποια κανονική έκφραση, αλλά χρησιμοποιούμε το <<EOF>>.
*/

%%

"char"              { printf("\nKEYWORD -> char\n"); return T_CHAR; }
"int"               { printf("\nKEYWORD -> int\n"); return T_INT; }
"float"             { printf("\nKEYWORD -> float\n"); return T_FLOAT; }
"void"              { printf("\nKEYWORD -> void\n"); return T_VOID; }
"if"                { printf("\nKEYWORD -> if\n"); return T_IF; }
"else"              { printf("\nKEYWORD -> else\n"); return T_ELSE; }
"while"             { printf("\nKEYWORD -> while\n"); return T_WHILE; }
"return"            { printf("\nKEYWORD -> return\n"); return T_RETURN; }
"main"              { printf("\nKEYWORD -> main\n"); return T_MAIN; }

"sizeof"            { printf("\nSIZEOP\n"); return T_SIZEOP; }

{ID}                { printf("\nID -> %s\n", yytext); return T_ID; }
{ICONST}            { printf("\nICONST -> %s\n", yytext); return T_ICONST; }
{FCONST}            { printf("\nFCONST -> %s\n", yytext); return T_FCONST; }
{CCONST}            { printf("\nCCONST -> %s\n", yytext); return T_CCONST; }

"||"                { printf("\nOROP\n"); return T_OROP; }
"&&"                { printf("\nANDOP\n"); return T_ANDOP; }
"=="|"!="           { printf("\nEQUOP -> %s\n", yytext); return T_EQUOP; }
">"|">="|"<"|"<="   { printf("\nRELOP -> %s\n", yytext); return T_RELOP; }
"+"|"-"             { printf("\nADDOP -> %s\n", yytext); return T_ADDOP; }
"*"|"/"|"%"         { printf("\nMULOP -> %s\n", yytext); return T_MULOP; }
"!"                 { printf("\nNOTOP\n"); return T_NOTOP; }
"++"|"--"           { printf("\nINCDEC -> %s\n", yytext); return T_INCDEC; }

"("                 { printf("\nLPAREN\n"); return T_LPAREN; }
")"                 { printf("\nRPAREN\n"); return T_RPAREN; }
";"                 { printf("\nSEMI\n"); return T_SEMI; }
","                 { printf("\nCOMMA\n"); return T_COMMA; }
"="                 { printf("\nASSIGN\n"); return T_ASSIGN; }
"["                 { printf("\nLBRACK\n"); return T_LBRACK; }
"]"                 { printf("\nRBRACK\n"); return T_RBRACK; }
"&"                 { printf("\nREFER\n"); return T_REFER; }
"{"                 { printf("\nLBRACE\n"); return T_LBRACE; }
"}"                 { printf("\nRBRACE\n"); return T_RBRACE; }

{WHITESPACE}        { /* Κενά (space) μέσα στο αρχείο - απλά τα αγνοούμε */ }
\n                  { lineno++; /* Εναλλακτικά βασιζόμαστε στο Flex να αυξήσει την μεταβλητή 'yylineno' κατά 1 ΑΥΤΟΜΑΤΑ */ }
<<EOF>>             { printf("\nEOF\n"); return T_EOF; }
.                   { error_count++; printf("\nUnrecognised character at line %d!\n", yylineno); }

%%

int main(int argc, char* argv[]) {

    int token; 

    yyin = fopen(argv[1], "r"); // Το yyin είναι ειδική μεταβλητή του Flex.
                                // Ισοδυναμεί με ένα FILE Pointer για να διαβάζει το αρχείο ο Flex

    if (yyin == NULL) {
        printf("%s: File not found\n", argv[1]);
        return 1;
    }

    do { // Μέχρι να φτάσουμε στο EOF διαβάζουμε κάθε Token μέσα απο το αρχείο.
        token = yylex();
    } while (token != T_EOF);

    return 0;
}