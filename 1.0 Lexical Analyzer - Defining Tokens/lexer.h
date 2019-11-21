//  Το 'T_' που προηγείται μπροστά από κάθε όνομα είναι συντομογραφία της λέξης 'token' που σημαίνει 'σύμβολο'.
//  Δεν είναι κάτι που πρέπει να προσθέσετε υποχρεωτικά, αλλά είναι μια καλή πρακτική να το κάνετε.

//  Για εμάς, ΟΤΙΔΗΠΟΤΕ διαβάζει το Flex από ένα αρχείο θα το αντιμετωπίζουμε ως σύμβολο, είτε είναι λέξη-κλειδί,
//  είτε κάποιο αναγνωριστικό (ID), είτε κάποιος τελεστής, κλπ.

//  Το αρχείο header (.h) θα μας χρειαστεί αργότερα για την "επικοινωνία" του Flex με το Bison.

//  Δίπλα σε κάθε όνομα μπορείτε να βάλετε ως κωδικό αναγνώρισης οποιονδήποτε ακέραιο αριθμό. Ωστόσο, προτείνεται
//  να ξεκινήσετε από το 1 και κάθε φορά να αυξάνετε τον κωδικό κατά 1.
//  Το τελευταίο σύμβολο 'T_EOF' (End Of File) πρέπει υποχρεωτικά να έχει κωδικό αναγνώρισης τον αριθμό 0.

//  Keywords
#define T_CHAR      1
#define T_INT       2
#define T_FLOAT     3
#define T_VOID      4
#define T_IF        5
#define T_ELSE      6
#define T_WHILE     7
#define T_RETURN    8
#define T_MAIN      9

//  Identifier
#define T_ID        10

//  Constants
#define T_ICONST    11
#define T_FCONST    12
#define T_CCONST    13
#define T_SCONST    14

//  Operators
#define T_OROP      15
#define T_ANDOP     16
#define T_EQUOP     17
#define T_RELOP     18
#define T_ADDOP     19
#define T_MULOP     20
#define T_NOTOP     21
#define T_INCDEC    22
#define T_SIZEOP    23

//  Other tokens
#define T_LPAREN    24
#define T_RPAREN    25
#define T_SEMI      26
#define T_COMMA     27
#define T_ASSIGN    28
#define T_LBRACK    29
#define T_RBRACK    30
#define T_REFER     31
#define T_LBRACE    32
#define T_RBRACE    33


//  EOF
#define T_EOF       0