// examples/gno.land/r/demo/forum/forum.gno
package forum

import (
	"bytes"
	"std"
	"strings"

	"gno.land/p/demo/forum"
	"gno.land/p/demo/ufmt"
)

// State of the Realm
var (
	name                   = "Gno Overflow"
	admin      std.Address = "g1enpvuf7yukrs7h4hgsqcu3jqygw7pjmad3k2tm"
	categories             = []string{"General", "Announcements", "Devs"}

	f           *forum.Forum
	forumPrefix      = "/r/demo/forum:" // used for routing
	postIndex   uint = 0
)

// init constructs the forum instance during deployment
func init() {
	f = forum.NewForum(name, categories, admin)
}

// AddModerator adds a new moderator to the forum
func AddModerator(moderator std.Address, category string) string {
	if !f.AddModerator(moderator, category) {
		return "unable to add moderator"
	}

	return "moderator successfully added"
}

// AddPost adds a new post to the forum
func AddPost(
	title string,
	body string,
	category string,
) string {
	// Create a new post
	p := forum.NewPost(postIndex, title, body, std.GetOrigCaller())
	p.SetCategory(category)

	// Add the post to the forum
	if !f.AddPost(p) {
		return "unable to add post"
	}

	// Increment the global post index
	postIndex++

	return ufmt.Sprintf("post successfully added with ID %d", postIndex-1)
}

// AddComment adds a new comment to a post
func AddComment(
	postID uint,
	body string,
) string {
	// Add the post to the forum
	if !f.AddComment(postID, body) {
		return "unable to add comment"
	}

	return "comment successfully added"
}

// RemovePost removes a post from the forum
func RemovePost(postID uint) string {
	if f.RemovePost(postID) {
		return "post successfully removed"
	}

	return "unable to remove post"
}

// Render displays the forum's content
func Render(path string) string {
	// Get the resource path
	parts := strings.Split(path, "/")

	switch {
	case path == "":
		return renderHomepage()
	case len(parts) == 2 && parts[0] == "post":
		post := f.GetPost(parts[1])
		if post == nil {
			return "post not found"
		}

		return renderPost(post)
	case len(parts) == 2 && parts[0] == "category":
		categoryPosts := f.GetCategoryPosts(parts[1])
		if len(categoryPosts) == 0 {
			return "no posts found"
		}

		return renderPostList(categoryPosts)
	default:
		return "post not found"
	}
}

// renderPostList renders a list of posts with their links
func renderPostList(posts []*forum.Post) string {
	var b bytes.Buffer

	for _, post := range posts {
		postURL := ufmt.Sprintf("%s%s%d", forumPrefix, "post/", post.GetID())
		b.WriteString(
			ufmt.Sprintf("### [%s](%s)\n", post.GetTitle(), postURL),
		)
	}

	return b.String()
}

// renderHomepage renders the homepage
func renderHomepage() string {
	var b bytes.Buffer

	// Write welcome message
	b.WriteString(
		ufmt.Sprintf("## Welcome to the %s forum!\n\n", f.GetName()),
	)

	// For each category, write the name
	for _, category := range f.GetCategories() {
		categoryURL := ufmt.Sprintf("%s%s%s", forumPrefix, "category/", category)
		b.WriteString(
			ufmt.Sprintf("## [Category: %s](%s)\n", category, categoryURL),
		)
	}

	return b.String()
}

// renderPost renders a post and its accompanying comments
func renderPost(p *forum.Post) string {
	var b bytes.Buffer

	// Write the title
	b.WriteString(
		ufmt.Sprintf("## %s\n", p.GetTitle()),
	)

	// Write the author and ID
	b.WriteString(
		ufmt.Sprintf("id: %d; author: **%s** \n", p.GetID(), p.GetAuthor().String()),
	)

	// Write the body
	b.WriteString(
		ufmt.Sprintf("\n%s\n", p.GetBody()),
	)

	// Write the comment section
	b.WriteString("## Comments\n\n")

	comments := p.GetComments()
	if len(comments) == 0 {
		b.WriteString("No comments to display")
	} else {
		for _, comment := range comments {
			b.WriteString(renderComment(comment))

			b.WriteString("\n")
		}
	}

	return b.String()
}

// renderComment renders a single comment
func renderComment(c *forum.Comment) string {
	var b bytes.Buffer

	// Write out the body
	b.WriteString(
		ufmt.Sprintf("%s\n\n", c.GetBody()),
	)

	// Write out the author
	b.WriteString(
		ufmt.Sprintf("author: %s\n", c.GetAuthor().String()),
	)

	return b.String()
}
