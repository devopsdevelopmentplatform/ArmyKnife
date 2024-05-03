#!/bin/bash

# Source the main library file
source "$(dirname "$0")/../lib/main.sh"

# Use the library functions
len=$(string_length "hello")
echo "Length of 'hello': $len"

sum=$(math_add 5 3)
echo "Sum of 5 and 3: $sum"
#!/bin/bash

