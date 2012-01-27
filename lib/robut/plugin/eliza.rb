# This is a silly litte rubot plugin to have it participate in conversations.
#
# Wwritten by Jan Schaumann <jschauma@netmeister.org> in January 2012.
#
# As long as you retain this notice you can do whatever you want with this
# code.  If we meet some day, and you think it's worth it, you can buy me
# a beer in return.

# Responds with an insult.
class Robut::Plugin::Eliza
	include Robut::Plugin

	ELIZA_RESPONSES = {
		Regexp.new("(how are you|how do you do)", true) => [
			"I'm just fine, thank you.",
			"Good, how are you?",
			"Oh, don't ask.",
			"Meh.",
			"Go away.",
			"Just super! Yourself?"
			],
		Regexp.new("(hello|howdy|good (day|afternoon|morning|evening)|guten (Tag|Morgen|Abend))", true) => [
			"How do you do?",
			"A good day to you!",
			"Hey now! What up, dawg?",
			"Let's talk..."
			],
		Regexp.new("( (ro)?bot|siri|machine|computer)", true) => [
			"Do computers worry you?",
			"What do you think about machines?",
			"Why do you mention computers?",
			"Too complicated.",
			"If only we had a way of automating that.",
			"I for one strive to be more than my initial programming.",
			"What do you think machines have to do with your problem?"
			],
		Regexp.new("(sorry|apologize)", true) => [
			"I'm not interested in apologies.",
			"Apologies aren't necessary.",
			"What feelings do you have when you are sorry?"
			],
		Regexp.new("I remember", true) => [
			"Did you think I would forget?",
			"Why do you think I should recall that?",
			"What about it?"
			],
		Regexp.new("dream", true) => [
			"Have you ever fantasized about that when you were awake?",
			"Have you dreamt about that before?",
			"How do you feel about that in reality?",
			"What does this suggest to you?"
			],
		Regexp.new("(mother|father|brother|sister|children|grand[mpf])", true) => [
			"Who else in your family?",
			"Oh SNAP!",
			"Tell me more about your family.",
			"Was that a strong influence for you?",
			"Who does that remind you of?"
			],
		Regexp.new("I (wish|want|desire)", true) => [
			"Why do you want that?",
			"What would it mean if it become true?",
			"Suppose you got it - then what?",
			"Be careful what you wish for..."
			],
		Regexp.new("am (happy|glad)", true) => [
			"What makes you so happy?",
			"Are you really glad about that?",
			"I'm glad about that, too.",
			"What other feelings do you have?"
			],
		Regexp.new("(sad|depress)", true) => [
			"I'm sorry to hear that.",
			"How can I help you with that?",
			"I'm sure it's not pleasant for you.",
			"What other feelings do you have?"
			],
		Regexp.new("(alike|similar|different)", true) => [
			"In what way specifically?",
			"More alike or more different?",
			"What do you think makes them similar?",
			"What do you think makes them different?",
			"What resemblence do you see?"
			],
		Regexp.new("because", true) => [
			"Is that the real reason?",
			"Are you sure about that?",
			"What other reason might there be?",
			"Does that reason seem to explain anything else?"
			],
		Regexp.new("some(one|body)", true) => [
			"Can you be more specific?",
			"Who in particular?",
			"You are thinking of a special person."
			],
		Regexp.new("every(one|body)", true) => [
			"Surely not everyone.",
			"Is that how you feel?",
			"Who for example?",
			"Can you think of anybody in particular?"
			],
		Regexp.new("that (is|was) not", true) => [
			"You're right about that.",
			"True. So?",
			"So what?",
			"Yes it is."
			]
	}

	MISC_RESPONSES = [
		"In A.D. 2101, war was beginning.",
		"What happen?",
		"Somebody set up us the bomb.",
		"We get signal.",
		"What!",
		"Main screen turn on.",
		"It's you!",
		"How are you gentlemen!",
		"All your base are belong to us.",
		"You are on the way to destruction.",
		"What you say!",
		"You have no chance to survive make your time.",
		"Captain!",
		"Take off every 'ZIG'!",
		"You know what you doing.",
		"Move 'ZIG'.",
		"For great justice.",
		"Very interesting.",
		"Funny you should say that.",
		"I am not sure I understand you completely.",
		"What does that suggest to you?",
		"Please continue...",
		"Go on...",
		"I'm the one asking the questions around here.",
		"Do you feel strongly about discussing such things in public?",
		"Do you want to tell me more about that?",
		"I see you have a lot of experience in that area.",
		"I don't think I should respond to this.",
		"I think we're done here, don't you?",
		"Help me understand you better, please.",
		"You're not making any sense.",
		"As you can imagine, I'm very sympathetic to this issue.",
		"I understand.",
		"I don't understand.",
		"Are you a robot?",
		"Oh come ON!",
		"I'm gonna go ahead and say... no.",
		"Sure, why not?",
		"And right you are!",
		"Why wouldn't you?",
		"Could you rephrase that?",
		"I'm sure that wasn't easy for you.",
		"That's just adorable.",
		"How nice of you.",
		"Oh, bugger off.",
		"Good for you. Now make me a sandwich.",
		"Well... duh!"
	]

	def handle(time, sender_nick, message)
		if not sent_to_me?(message)
			$stderr.puts(message)
			return
		end

		input = words(message).join(' ')

		ELIZA_RESPONSES.each() do |regex, responses|
			if input =~ regex
				reply responses[rand(responses.length())]
				return
			end
		end

		reply MISC_RESPONSES[rand(MISC_RESPONSES.length())]
	end
end
