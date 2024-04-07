package forum

import "std"

type Post struct {
	id uint

	title    string
	body     string
	category string

	comments []*Comment
	author   std.Address
}

func NewPost(id uint, title, body string, author std.Address) *Post {
	return &Post{
		id:       id,
		title:    title,
		body:     body,
		author:   author,
		comments: make([]*Comment, 0),
	}
}

// GetID returns the post's ID
func (p Post) GetID() uint {
	return p.id
}

// GetTitle returns the post's title
func (p Post) GetTitle() string {
	return p.title
}

// GetBody returns the post's body
func (p Post) GetBody() string {
	return p.body
}

// GetAuthor returns the post's author (address)
func (p Post) GetAuthor() std.Address {
	return p.author
}

// GetCategory returns the post's category
func (p Post) GetCategory() string {
	return p.category
}

// SetCategory sets the post's category
func (p *Post) SetCategory(category string) {
	p.category = category
}

// AddComment adds a new comment to a post
func (p *Post) AddComment(comment *Comment) {
	p.comments = append(p.comments, comment)
}

// GetComments returns the comments on a post
func (p Post) GetComments() []*Comment {
	return p.comments
}
