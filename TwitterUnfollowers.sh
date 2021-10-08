
/*
	Unfollow (stop following) those people who are not following you back on Twitter (or unfollow everyone if desired).

	This will work for new Twitter web site code structure (it was changed from July 2019, causing other unfollow-scripts to stop working).

	Instructions:
	1) The code may need to be modified depending on the language of your Twitter web site:
		* For English language web site, no modification needed.
		* For Spanish language web site, remember to set the 'LANGUAGE' variable to "ES".
		* For another language, remember to set the 'LANGUAGE' variable to that language and modify the 'WORDS' object to add the words in that language.
	2) Optionally, you can edit the 'SKIP_USERS' array to insert those users that you do not want to unfollow (even if they are not following you back).
	3) If you want to follow everyone (except the users in 'SKIP_USERS'), including those who are following you, just set the 'UNFOLLOW_FOLLOWERS' variable to 'true'.
	4) You can set the milliseconds per cycle (each call to the 'performUnfollow' function) by modifying the 'MS_PER_CYCLE' variable.
	5) If desired, set a number to the 'MAXIMUM_UNFOLLOW_ACTIONS_PER_CYCLE' variable to establish a maximum of unfollow actions to perform for each cycle (each call to the 'performUnfollow' function). Set to null to have no limit.
	6) If desired, set a number to the 'MAXIMUM_UNFOLLOW_ACTIONS_TOTAL' variable to establish a maximum of unfollow actions to perform in total for all cycles (all calls to the 'performUnfollow' function). Set to null to have no limit.
	7) When the code is fine, on Twitter web site, go to the section where it shows all the people you are following (https://twitter.com/YOUR_USERNAME_HERE/following).
	8) Once there, open the JavaScript console (F12 key, normally), paste all the code there and press enter.
	9) Wait until you see it has finished. If something goes wrong or some users were not unfollowed, reload the page and repeat from the step 8 again.

	* Gist by Joan Alba Maldonado: https://gist.github.com/jalbam/d7678c32b6f029c602c0bfb2a72e0c26
*/


var LANGUAGE = "EN"; //NOTE: change it to use your language!
var WORDS =
{
	//English language:
	EN:
	{
		followsYouText: "Follows you", //Text that informs that follows you.
		followingButtonText: "Following", //Text of the "Following" button.
		confirmationButtonText: "Unfollow" //Text of the confirmation button. I am not totally sure.
	},
	//Spanish language:
	ES:
	{
		followsYouText: "Te sigue", //Text that informs that follows you.
		followingButtonText: "Siguiendo", //Text of the "Following" button.
		confirmationButtonText: "Dejar de seguir" //Text of the confirmation button. I am not totally sure.
	}
	//NOTE: if needed, add your language here...
}
var UNFOLLOW_FOLLOWERS = false; //If set to true, it will also remove followers (unless they are skipped).
var MS_PER_CYCLE = 20; //Milliseconds per cycle (each call to 'performUnfollow').
var MAXIMUM_UNFOLLOW_ACTIONS_PER_CYCLE = null; //Maximum of unfollow actions to perform, per cycle (each call to 'performUnfollow'). Set to 'null' to have no limit.
var MAXIMUM_UNFOLLOW_ACTIONS_TOTAL = 5400; //Maximum of unfollow actions to perform, in total (among all calls to 'performUnfollow'). Set to 'null' to have no limit.
var SKIP_USERS = //Users that we do not want to unfollow (even if they are not following you back):
[
	//Place the user names that you want to skip here (they will not be unfollowed):
	"user_name_to_skip_example_1",
	"user_name_to_skip_example_2",
	"user_name_to_skip_example_3"
];
SKIP_USERS.forEach(function(value, index) { SKIP_USERS[index] = value.toLowerCase(); }); //Transforms all the user names to lower case as it will be case insensitive.

var _UNFOLLOWED_TOTAL = 0; //Keeps the number of total unfollow actions performed. Read-only (do not modify).

//Function that unfollows non-followers on Twitter:
var performUnfollow = function(followsYouText, followingButtonText, confirmationButtonText, unfollowFollowers, maximumUnfollowActionsPerCycle, maximumUnfollowActionsTotal)
{
	var unfollowed = 0;
	followsYouText = followsYouText || WORDS.EN.followsYouText; //Text that informs that follows you.
	followingButtonText = followingButtonText || WORDS.EN.followingButtonText; //Text of the "Following" button.
	confirmationButtonText = confirmationButtonText || WORDS.EN.confirmationButtonText; //Text of the confirmation button.
	unfollowFollowers = typeof(unfollowFollowers) === "undefined" || unfollowFollowers === null ? UNFOLLOW_FOLLOWERS : unfollowFollowers;
	maximumUnfollowActionsTotal = maximumUnfollowActionsTotal === null || !isNaN(parseInt(maximumUnfollowActionsTotal)) ? maximumUnfollowActionsTotal : MAXIMUM_UNFOLLOW_ACTIONS_TOTAL || null;
	maximumUnfollowActionsTotal = !isNaN(parseInt(maximumUnfollowActionsTotal)) ? parseInt(maximumUnfollowActionsTotal) : null;
	maximumUnfollowActionsPerCycle = maximumUnfollowActionsPerCycle === null || !isNaN(parseInt(maximumUnfollowActionsPerCycle)) ? maximumUnfollowActionsPerCycle : MAXIMUM_UNFOLLOW_ACTIONS_PER_CYCLE || null;
	maximumUnfollowActionsPerCycle = !isNaN(parseInt(maximumUnfollowActionsPerCycle)) ? parseInt(maximumUnfollowActionsPerCycle) : null;

	//Looks through all the containers of each user:
	var totalLimitReached = false;
	var localLimitReached = false;
	var userContainers = document.querySelectorAll('[data-testid=UserCell]');
	Array.prototype.filter.call
	(
		userContainers,
		function(userContainer)
		{
			//If we have reached a limit previously, exits silently:
			if (totalLimitReached || localLimitReached) { return; }
			//If we have reached the maximum desired number of total unfollow actions, exits:
			else if (maximumUnfollowActionsTotal !== null && _UNFOLLOWED_TOTAL >= maximumUnfollowActionsTotal) { console.log("Exiting! Limit of unfollow actions in total reached: " + maximumUnfollowActionsTotal); totalLimitReached = true; return;  }
			//...otherwise, if we have reached the maximum desired number of local unfollow actions, exits:
			else if (maximumUnfollowActionsPerCycle !== null && unfollowed >= maximumUnfollowActionsPerCycle) { console.log("Exiting! Limit of unfollow actions per cycle reached: " + maximumUnfollowActionsPerCycle); localLimitReached = true; return;  }

			//Checks whether the user is following you:
			if (!unfollowFollowers)
			{
				var followsYou = false;
				Array.from(userContainer.querySelectorAll("*")).find
				(
					function(element)
					{
						if (element.textContent === followsYouText) { followsYou = true; }
					}
				);
			}
			else { followsYou = false; } //If we want to also unfollow followers, we consider it is not a follower.

			//If the user is not following you (or we also want to unfollow followers):
			if (!followsYou)
			{
				//Finds the user name and checks whether we want to skip this user or not:
				var skipUser = false;
				var userName = "";
				Array.from(userContainer.querySelectorAll("[href^='/']")).find
				(
					function (element)
					{
						if (skipUser) { return; }
						if (element.href.indexOf("search?q=") !== -1 || element.href.indexOf("/") === -1) { return; }
						userName = element.href.substring(element.href.lastIndexOf("/") + 1).toLowerCase();
						Array.from(element.querySelectorAll("*")).find
						(
							function (subElement)
							{
								if (subElement.textContent.toLowerCase() === "@" + userName)
								{
									if (SKIP_USERS.indexOf(userName) !== -1)
									{
										console.log("We want to skip: " + userName);
										skipUser = true;
									}
								}
							}
						);
					}
				);

				//If we do not want to skip the user:
				if (!skipUser)
				{
					//Finds the unfollow button:
					Array.from(userContainer.querySelectorAll('[role=button]')).find
					(
						function(element)
						{
							//If the unfollow button is found, clicks it:
							if (element.textContent === followingButtonText)
							{
								console.log("* Unfollowing: " + userName);
								element.click();
								unfollowed++;
								_UNFOLLOWED_TOTAL++;
							}
						}
					);
				}
			}
		}
	);

	//If there is a confirmation dialog, press it automatically:
	Array.from(document.querySelectorAll('[role=button]')).find //Finds the confirmation button.
	(
		function(element)
		{
			//If the confirmation button is found, clicks it:
			if (element.textContent === confirmationButtonText)
			{
				element.click();
			}
		}
	);

	return totalLimitReached ? null : unfollowed; //If the total limit has been reached, returns null. Otherwise, returns the number of unfollowed people.
}


//Scrolls and unfollows non-followers, constantly:
var scrollAndUnfollow = function()
{
	window.scrollTo(0, document.body.scrollHeight);
	var unfollowed = performUnfollow(WORDS[LANGUAGE].followsYouText, WORDS[LANGUAGE].followingButtonText, WORDS[LANGUAGE].confirmationButtonText, UNFOLLOW_FOLLOWERS, MAXIMUM_UNFOLLOW_ACTIONS_PER_CYCLE, MAXIMUM_UNFOLLOW_ACTIONS_TOTAL); //For English, you can try to call it without parameters.
	if (unfollowed !== null) { setTimeout(scrollAndUnfollow, MS_PER_CYCLE); }
	else { console.log("Total desired of unfollow actions performed!"); }
};
scrollAndUnfollow();
