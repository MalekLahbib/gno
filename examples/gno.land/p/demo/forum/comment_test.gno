package forum

import (
	"std"
	"testing"

	"gno.land/p/demo/testutils"
)

func Test_NewComment(t *testing.T) {
	const (
		body   string      = "This comment body"
		author std.Address = testutils.TestAddress("author")
	)

	std.TestSetOrigCaller(author)
	p := NewComment(body)

	if p.GetBody() != body {
		t.Fatalf("invalid body")
	}

	if p.GetAuthor().String() != author.String() {
		t.Fatalf("invalid author")
	}
}
