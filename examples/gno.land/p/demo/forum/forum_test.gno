// examples/gno.land/p/demo/forum/forum_test.gno
package forum

import (
	"std"
	"testing"

	"gno.land/p/demo/testutils"
	"gno.land/p/demo/ufmt"
)

// TestForum_New verifies that a new forum
// can be initialized correctly
func TestForum_New(t *testing.T) {
	var (
		name       = "forum name"
		categories = []string{"category 1", "category 2", "category 3"}
		admin      = testutils.TestAddress("admin")
	)

	// Create a new forum instance
	f := NewForum(name, categories, admin)

	// Verify it has been initialized correctly
	if f.GetName() != name {
		t.Fatalf("invalid name")
	}

	if !f.isAdmin(admin) {
		t.Fatalf("invalid admin")
	}

	for index, category := range f.GetCategories() {
		if categories[index] != category {
			t.Fatalf("invalid category")
		}
	}
}

// TestForum_AddPost verifies that the post can
// be added to the forum
func TestForum_AddPost(t *testing.T) {
	var (
		// Forum info
		name       = "forum name"
		categories = []string{"category 1"}
		admin      = testutils.TestAddress("admin")

		// Post info
		author       = testutils.TestAddress("author")
		postID       = uint(0)
		postCategory = categories[0]
		postTitle    = "post title"
		postBody     = "post body"
	)

	// Create a new forum instance
	f := NewForum(name, categories, admin)

	// Create a new post
	p := NewPost(postID, postTitle, postBody, author)
	p.SetCategory(postCategory)

	// Add the post
	if !f.AddPost(p){
		t.Fatalf("unable to add post to forum")
	}

	// Get all the posts
	posts := f.GetPosts()

	if len(posts) != 1 {
		t.Fatalf("invalid number of posts")
	}

	// Get all the category posts
	categoryPosts := f.GetCategoryPosts(categories[0])
	if len(categoryPosts) != 1 {
		t.Fatalf("invalid number of category posts")
	}
}

// TestForum_RemovePost verifies that a post
// can be removed by the moderator and admin users
func TestForum_RemovePost(t *testing.T) {
	var (
		admin     = testutils.TestAddress("admin")
		moderator = testutils.TestAddress("moderator")

		categories = []string{"category 1", "category 2"}
	)

	// Create a new forum instance
	f := NewForum(
		"forum example",
		categories,
		admin,
	)

	// Add a moderator for a category
	std.TestSetOrigCaller(admin)
	f.AddModerator(moderator, categories[0])

	// Add two posts, one to be removed by the admin
	// and the other to be removed by the moderator
	p := NewPost(0, "", "", testutils.TestAddress("author"))
	p.SetCategory(categories[0])
	if !f.AddPost(p) {
		t.Fatalf("unable to add post")
	}

	p = NewPost(1, "", "", testutils.TestAddress("author"))
	p.SetCategory(categories[0])
	if !f.AddPost(p) {
		t.Fatalf("unable to add post")
	}

	if len(f.GetPosts()) != 2 {
		t.Fatalf("invalid number of posts, %d", len(f.GetPosts()))
	}

	// Remove a post as the admin
	std.TestSetOrigCaller(admin)
	if !f.RemovePost(0) {
		t.Fatalf("unable to remove post as admin")
	}

	// Remove a post as a moderator
	std.TestSetOrigCaller(moderator)
	if !f.RemovePost(1) {
		t.Fatalf("unable to remove post as moderator")
	}

	// Check that both posts were removed
	if len(f.GetPosts()) != 0 {
		t.Fatalf("invalid number of posts, should be 0")
	}

	if len(f.GetCategoryPosts(categories[0])) != 0 {
		t.Fatalf("invalid number of category posts, should be 0")
	}
}

// TestForum_AddComment verifies that a comment
// can be added by a user to a post
func TestForum_AddComment(t *testing.T) {
	// Create a new forum instance
	f := NewForum(
		"forum example",
		[]string{"category 1"},
		testutils.TestAddress("admin"),
	)

	// Create a new post
	p := NewPost(0, "", "", testutils.TestAddress("pAuthor"))
	p.SetCategory("category 1")
	if !f.AddPost(p) {
		t.Fatalf("unable to add post")
	}

	// Add a comment to the post
	var (
		commentAuthor = testutils.TestAddress("commenter")
		commentBody   = "Example comment body"
	)

	std.TestSetOrigCaller(commentAuthor)
	if !f.AddComment(p.GetID(), commentBody) {
		t.Fatalf("unable to add comment to post")
	}

	comments := f.GetComments(p.GetID())
	if len(comments) != 1 {
		t.Fatalf("invalid comment number")
	}

	if comments[0].GetAuthor().String() != commentAuthor.String() {
		t.Fatalf("invalid comment authro")
	}

	if comments[0].GetBody() != commentBody {
		t.Fatalf("invalid comment body")
	}
}
