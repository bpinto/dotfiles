function proxy-to-amazon
  command ssh -i ~/.ssh/bruno-ec2.pem -D 2001 -N ubuntu@ec2-107-20-45-205.compute-1.amazonaws.com
end
