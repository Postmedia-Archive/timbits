h1 @story.Title

div @story.Body.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&')