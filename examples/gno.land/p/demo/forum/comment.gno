package forum

import "std"

type Comment struct {
	body string

	author std.Address
}

func NewComment(body string) *Comment {
	return &Comment{
		body:   body,
		author: std.GetOrigCaller(),
	}
}

// GetBody returns the comment body
func (c Comment) GetBody() string {
	return c.body
}

// GetAuthor returns the comment author
func (c Comment) GetAuthor() std.Address {
	return c.author
}
