// examples/gno.land/p/forum/post_test.gno
package forum

import (
	"std"
	"testing"

	"gno.land/p/demo/testutils"
)

// TestPost_New verifies that a
// new forum post can be created successfully
func TestPost_New(t *testing.T) {
	var (
		id       uint        = 123
		title                = "Example Post Title"
		body                 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
		category             = "category 1"
		author   std.Address = testutils.TestAddress("author")
	)

	// Create a new post
	p := NewPost(id, title, body, author)
	p.SetCategory(category)

	// Check that the data matches
	if p.GetID() != id {
		t.Fatalf("invalid ID")
	}

	if p.GetTitle() != title {
		t.Fatalf("invalid title")
	}

	if p.GetBody() != body {
		t.Fatalf("invalid body")
	}

	if p.GetCategory() != category {
		t.Fatalf("invalid category")
	}

	if p.GetAuthor().String() != author.String() {
		t.Fatalf("invalid author")
	}
}
