
preview at: https://goldenblog-vuducvi.herokuapp.com/

## Admin account
email: vuducvi20@gmail.com

password: anhvipanndan


## Features
	Overview
1. **Post ranking**

Post was sorted by:
- created_by (news posts)
- average of rates score (top rating)
- number of read count (most reading)

<div align='center'>
	<img src="https://user-images.githubusercontent.com/57878618/136640471-3018c1a8-a424-4009-af40-0646f9906c82.png" width="300" height="150">
</div>

- weekly
- monthly
- yearly

<div align='center'>
	<img src="https://user-images.githubusercontent.com/57878618/136640551-9fb19af2-bb74-4886-8b0b-d7092f3316b2.png" width="318" height="100">
</div>

2. **Search posts**

You can pick a category listed at home page to search.
Or you can use detailed search modal.

<div align='center'>
	<img src="https://user-images.githubusercontent.com/57878618/136640673-16c176fb-82e1-4655-84de-81ac74831e68.png" width="263" height="233">
</div>

Key words searching may not as same as original post title. It could be related. For example, original title is “**Open Source in Everyday Life**”, you can type “**open life**” or “**source every**”.

3. **Post reactions**.

You can give a like to a post
<div align="left">
	<img src="https://user-images.githubusercontent.com/57878618/136640776-cf3b9c99-0de4-4f05-935c-40d8b5a68c9e.png" width="53" height="68">
</div>
     
You visit a post, read count of post will update. But it will block spamming read count when you try to refresh or open many tabs. This feature is quite dump because I created it base on localStorate. It can be spamed by open anonymous browser again and again.
<div align="left">
	<img src="https://user-images.githubusercontent.com/57878618/136640996-3386467e-6f33-4d57-82a1-7e8d6696708e.png" width="60" height="60">
</div>

When you leave a comment or onother user does it, post comments will update. Even you reply comment at that post, that mean nested comments is calculated as well.
<div align="left">
	<img src="https://user-images.githubusercontent.com/57878618/136641039-789cc7f1-0fde-4f76-b36c-21f7c075c5c5.png" width="54" height="68">
</div>

Share post to facebook or give a rating from 1..5 score
<div align="left">
	<img src="https://user-images.githubusercontent.com/57878618/136641068-b46f3c1f-bc7c-4a28-b123-18fe975e5798.png" width="150" height="120">
</div>

4. **Related posts and more from author**.

Related posts is top 5 posts and was sorted by most reading of same categories.

More from author is top 3 posts and was sorted by most reading of same author.

5. **Ajax request**.

Ajax request basically is about post reacting. When you reacts with a post, an ajax request will call to server and trigger javascript to update UI when respond status is successed.

For example: when you click like post, the heart will witch to red color and if you refresh page, the UI is still same. Normally, you just click like and nothing happen, you must refresh page after to see the difference.

List ajax request:
- like or unlike post.
- rate post.
- create, edit, delete comment.
- comment count.
- approve, reject post by admin.

6. **Notifications realtime**.

List cases to receive new notification, whenever:
- Have new reply comment.
- Have new comment on your post.
- You post was given a like.
<div align="left">
	<img src="https://user-images.githubusercontent.com/57878618/136641297-14cebba6-23ad-4dec-8030-ba891ba944c5.png" width="280" height="350">
</div>

<a id='authorization'></a>

	authorization
1. **Sign in**.

Sign in by email and password. You can also have “remember be” option if you want to expand you session up to 1 week, otherwise you will auto expired session if there is no activity after 1 hour. Beside, when you sign out, “remember me” session is auto expired, you have to sign in again to grant new session.

If you tryting to sign in over 5 times. You will be lock for 2 hours and an email unlock will auto send to your signed in email. If you dont receive, you may want to use option “Didn't receive unlock instructions?”

2. **Sign up**.

Require username, email and password. If there is already username or email, or you haven’t type enough fields, you will get a error message.

After sign up, you will have email instruction to active account which must active within 3 days. If you haven’t got any email instruction or instruction had been expired, you may want to use option “Didn't receive confirmation instructions?”.

3. **Forgot your password**?

An email instruction will send to your email to reset password.

4. **Social account login**.

You can have 2 options are Gmail or Facebook account. After sign in, you may want to change profile infomations because current infomations is set based on social account informations.

	Authorized member
1. **User**.

User have permissions of reacting with post (like, rate, comment).

User also can create, edit or delete their posts.

Finally, only user and admin can have their own realtime notifications.

Post can be published to facebook fanpage ([https://www.facebook.com/PhucVu2005App](https://www.facebook.com/PhucVu2005App)) as user want, after approved by admin.

<div align="center">
	<img src="https://user-images.githubusercontent.com/57878618/136641539-41e8846e-5096-4f81-89f5-4bd47a135f83.png" width="380" height="450">
</div>

2. **Admin**.

Admin can also have access to react with post and have realtime notifications as well.

Admin cannot create posts like user, but admin can create categories, and manage posts (approve or reject).

Admin have permission to access fanpage ([https://www.facebook.com/PhucVu2005App](https://www.facebook.com/PhucVu2005App))

	Email notifications
	
First type of email you can receive is registration and instructions, i have listed them above, at [authorization](#authorization)

Beside, here is some announcement you can have:
- You have created your post.
- You have edited your post.
- You have deleted your post.
- Your post had been approved by admin.
- Your post had been reject by admin.


## Gems and rails components used

1. Gems
- Devise – build authorization
- Pundit – build authentication
- Slim – template engine
- Delayed job – background process
- Koala – Facebook API operations
	
2. Rails components
	
- Action mailer
- Active storage
- Action cable


## Error solving
1. **_Sign up_ for new account**

	If you get this error when you try to create account, that is because gmail prevent any access from new location (our app). Now we need to grant required access by going to http://www.google.com/accounts/DisplayUnlockCaptcha and click continue. After this step, gmail will let 10 minutes for registering new app. 
	 
   Try to read https://support.google.com/mail/answer/7126229  at I can't sign in to my email client.
   
<div align='center'>
	<img src="https://user-images.githubusercontent.com/57878618/136525846-4f86e9f6-18d8-4a2f-af56-c3eca26eee17.png" width="400" height="300">
</div>

2. **Haven’t got any email, try to search on spam email.**

3. **Contact us page is not working.**

	This should be a feature but I haven’t done yet.

4. **My thumnail post was gone after a night?**

	Heroku platform is auto remove uploaded attachment after 24h
	
## References
Template: https://startbootstrap.com/theme/clean-blog
