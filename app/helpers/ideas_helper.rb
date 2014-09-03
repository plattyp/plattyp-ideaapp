module IdeasHelper
	def trackerprogress(stepnum,stepat)
		if stepnum === stepat
			"btn btn-primary active"
		elsif stepnum < stepat
			"btn btn-primary"
		else
			"btn btn-default"
		end
	end
end
