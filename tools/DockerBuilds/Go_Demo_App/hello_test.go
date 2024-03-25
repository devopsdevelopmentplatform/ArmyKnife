// hello_test.go

package main

import (
	"io"
	"bytes"
	"os"
	"testing"
)

func TestHelloWorld(t *testing.T) {
	// Create a pipe to capture output
	r, w, err := os.Pipe()
	if err != nil {
		t.Fatal(err)
	}
	defer r.Close()
	defer w.Close()

	// Backup os.Stdout and redirect it to the pipe writer
	old := os.Stdout
	os.Stdout = w

	// Restore os.Stdout when the function exits
	defer func() {
		os.Stdout = old
	}()

	// Run our main function
	main()

	// Close the writer so that the reader can read the data
	w.Close()

	// Read from the pipe to get the output
	var buf bytes.Buffer
	io.Copy(&buf, r)

	// Check if the output matches "Hello, World!"
	want := "Hello, World!\n"
	got := buf.String()
	if got != want {
		t.Errorf("got %q want %q", got, want)
	}
}


