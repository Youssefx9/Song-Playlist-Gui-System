local Main = {}

Main.Music_Folder = game:GetService("ReplicatedStorage"):WaitForChild("Music")

Main.Sounds = {}

for i, v in ipairs(Main.Music_Folder:GetDescendants()) do
	table.insert(Main.Sounds, v)
end

function Main:StopPlayingSounds(Ignorance)
	for i, V in pairs(Main.Music_Folder:GetChildren()) do
		if V.Name ~= Ignorance.Name and V:IsA("Sound") then
			V:Pause()
		end
	end
end

function Main:SPS2(ingorance)
	for i, v in ipairs(Main.Sounds) do
		if v ~= ingorance and v:IsA("Sound") then
			v:Stop()
		end
	end
end

function Main:ChangeColor(ImageButton:ImageButton,TargetColor)
	local ogColor = ImageButton.ImageColor3
	if string.lower(TargetColor) == "green" then
		ImageButton.MouseButton1Click:Connect(function()
			ImageButton.ImageColor3 = Color3.new(0.0705882, 1, 0.0196078)
			wait(0.5)
			ImageButton.ImageColor3 = ogColor
		end)

		ImageButton.MouseButton1Down:Connect(function()
			ImageButton.ImageColor3 = Color3.new(0.0705882, 1, 0.0196078)
		end)

		ImageButton.MouseButton1Up:Connect(function()
			ImageButton.ImageColor3 = ogColor
		end)
	end

	if string.lower(TargetColor) == "red" then
		ImageButton.MouseButton1Click:Connect(function()
			ImageButton.ImageColor3 = Color3.new(1, 0, 0.0156863)
		end)

		ImageButton.MouseButton1Down:Connect(function()
			ImageButton.ImageColor3 = Color3.new(1, 0, 0.0156863)
		end)
		ImageButton.MouseButton1Up:Connect(function()
			ImageButton.ImageColor3 = ogColor
		end)
	end

end

local function TweenPlay(Button:ImageButton, Green)
	--0, 163,0, 65
	if Green == "green" then
		local tween = game:GetService("TweenService"):Create(Button.Playing_Frame, TweenInfo.new(0.5, Enum.EasingStyle.Circular), {BackgroundColor3 = Color3.new(0.133333, 1, 0), Size =  UDim2.new(0, 37,0, 65)})
		local Tweeb = game:GetService("TweenService"):Create(Button.Name_Label, TweenInfo.new(0.5, Enum.EasingStyle.Circular), {Position = Button.Name_Label.Position + UDim2.new(0.049,0,0,0)})
		tween:Play()
		Tweeb:Play()
		Button.Playing_Frame.Visible = true
	end
	
	if Green == "og" then
		local tween2 = game:GetService("TweenService"):Create(Button.Playing_Frame, TweenInfo.new(0.5, Enum.EasingStyle.Circular), {BackgroundColor3 = Color3.new(0.121569, 0.121569, 0.121569), Size = UDim2.new(0,0,0,65)})
		local Tweeb = game:GetService("TweenService"):Create(Button.Name_Label, TweenInfo.new(0.5, Enum.EasingStyle.Circular), {Position = Button.Name_Label.Position - UDim2.new(0.049,0,0,0)})
		tween2:Play()
		Tweeb:Play()
		Button.Playing_Frame.Visible = false
	end
end

function Main:CreateButton(Sound_FileObject:Sound,Template:ImageButton)
	local Music_Button = Template:Clone()
	Music_Button.Parent = Template.Parent
	Music_Button.Visible = true
	local V = Music_Button:FindFirstChildOfClass("ObjectValue")
	V.Value = Sound_FileObject
	
	local Name_Label = Music_Button.Name_Label
	local Play_Button = Music_Button.Play_Button
	local Pause_Button = Music_Button.Pause_Button
	local Previous_Button = Music_Button.Previous_Button

	Music_Button.Name = Sound_FileObject.Name
	Name_Label.Text = Sound_FileObject.Name
	
	Sound_FileObject.Paused:Connect(function()
		TweenPlay(Music_Button, "og")
	end)
	
	Sound_FileObject.Stopped:Connect(function()
		TweenPlay(Music_Button, "og")
	end)
	
	Sound_FileObject.Resumed:Connect(function()
		TweenPlay(Music_Button, "green")
	end)
	
	Sound_FileObject.Played:Connect(function()
		TweenPlay(Music_Button, "green")
	end)
	
	Play_Button.Activated:Connect(function()
		repeat
			wait()
		until Sound_FileObject.IsLoaded == true
		if Sound_FileObject.Playing then return end

		if Sound_FileObject.Playing == false then
			Main:StopPlayingSounds(Sound_FileObject)
			if Sound_FileObject.TimePosition > 0 then
				Main:ChangeColor(Play_Button, "green")
				Sound_FileObject:Resume()
			else
				Main:ChangeColor(Play_Button, "green")
				Sound_FileObject:Play()
				TweenPlay(Music_Button, "green")
			end
		end
	end)

	Pause_Button.Activated:Connect(function()
		repeat
			wait()
		until Sound_FileObject.IsLoaded == true
		if Sound_FileObject.IsPlaying == true then
			Main:ChangeColor(Pause_Button, "red")
			Sound_FileObject:Pause()
		end
	end)

	Previous_Button.Activated:Connect(function()
		repeat
			wait()
		until Sound_FileObject.IsLoaded == true

		if Sound_FileObject.TimePosition > 0 then
			Sound_FileObject:Stop()
		end
		if Sound_FileObject.TimePosition == 0  then 
			local Index = table.find(Main.Sounds, Sound_FileObject)
			print(Index)
			if Index then
				if Index == 1 then return end
				if Index > 1 then
					warn("Current Index is: "..Index)
					local Previous_Song = Index-1
					warn("Now Playing Index of: "..Previous_Song)
					Main:SPS2(Previous_Song)
					Main.Sounds[Previous_Song]:Play()
				end
			end
		end
		if Sound_FileObject.TimePosition > 0 then
			Sound_FileObject:Stop()
		end
	end)
end
function Main:Init(Template)
	for i, v in ipairs(Main.Sounds) do
		Main:CreateButton(v, Template)
	end
end
return Main
